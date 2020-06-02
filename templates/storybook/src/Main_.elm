module Main_ exposing (main)

import Browser
import Browser.Navigation as Nav
import Dict
import Html.Styled exposing (..)
import Route
import Stories exposing (Story)
import Stories.Example as Example
import Storybook
import String.Extra
import Url


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | ExampleMsg Example.Msg


type alias Model =
    { url : Url.Url
    , key : Nav.Key
    , pages : List (Story Msg)
    , active : Maybe ( String, Storybook.View Msg )
    , pageUrlDict : Dict.Dict String (Html Msg)
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        pages : List (Story Msg)
        pages =
            List.concat
                [ Example.pages ExampleMsg
                ]

        urlDict : List (Story Msg) -> Dict.Dict String (Html Msg)
        urlDict stories =
            stories
                |> List.map
                    (\s ->
                        List.map
                            (\ss ->
                                ( String.Extra.underscored (Tuple.first s ++ " " ++ Tuple.first ss)
                                , Tuple.second ss
                                )
                            )
                            (Tuple.second s)
                    )
                |> List.concat
                |> Dict.fromList

        pageUrlDict : Dict.Dict String (Html Msg)
        pageUrlDict =
            urlDict pages

        route : Maybe Route.Route
        route =
            Route.fromUrl url

        active : Maybe ( String, Storybook.View Msg )
        active =
            case route of
                Just (Route.Page path) ->
                    Dict.get path pageUrlDict
                        |> Maybe.map (\p -> ( path, Storybook.Page p ))

                _ ->
                    Nothing
    in
    ( Model url key pages active pageUrlDict, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested req ->
            case req of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        UrlChanged url ->
            let
                route : Maybe Route.Route
                route =
                    Route.fromUrl url

                active : Maybe ( String, Storybook.View Msg )
                active =
                    case route of
                        Just (Route.Page path) ->
                            Dict.get path model.pageUrlDict
                                |> Maybe.map (\p -> ( path, Storybook.Page p ))

                        _ ->
                            Nothing
            in
            ( { model | active = active }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view { pages, active } =
    { title = "Storybook | Merchant Web Elm"
    , body =
        [ toUnstyled <|
            Storybook.view
                { pages = pages
                , active = active
                }
        ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }
