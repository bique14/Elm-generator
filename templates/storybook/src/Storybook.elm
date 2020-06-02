module Storybook exposing (View(..), view)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, classList, css, href)
import Stories exposing (Story)
import Storybook.Svg exposing (sick)
import String.Extra


type alias Model msg =
    { pages : List (Story msg)
    , active : Maybe ( String, View msg )
    }


type View msg
    = Component (Html msg)
    | Page (Html msg)


view : Model msg -> Html msg
view model =
    div [ class "flex h-full" ]
        [ viewStoryMenu model.active model.pages
        , div [ class "flex-1 bg-gray-100 p-4 h-full" ]
            [ case model.active of
                Just ( _, Page page ) ->
                    div [ class "rounded-lg shadow bg-white overflow-auto h-full" ]
                        [ page
                        ]

                _ ->
                    div [] []
            ]
        ]


toPath : String -> String -> String
toPath groupName storyName =
    String.Extra.underscored (groupName ++ " " ++ storyName)


toComponentPath : String -> String -> String
toComponentPath groupName storyName =
    "/component/" ++ toPath groupName storyName


toPagePath : String -> String -> String
toPagePath groupName storyName =
    "/page/" ++ toPath groupName storyName


viewStoryMenu : Maybe ( String, View msg ) -> List (Story msg) -> Html msg
viewStoryMenu active pages =
    let
        toPageMenu : Story msg -> Html msg
        toPageMenu story =
            li []
                [ div []
                    [ h3 [ class "font-bold" ]
                        [ text <| Tuple.first story ]
                    , ul [ class "pl-4" ] <|
                        List.map
                            (toSubPageMenu (Maybe.map Tuple.first active) (Tuple.first story))
                            (Tuple.second story)
                    ]
                ]

        toSubPageMenu : Maybe String -> String -> ( String, Html msg ) -> Html msg
        toSubPageMenu activePath group sub =
            let
                path : String
                path =
                    String.Extra.underscored (group ++ " " ++ Tuple.first sub)

                isActive : Bool
                isActive =
                    activePath == Just path
            in
            li [ class "relative" ]
                [ a
                    [ href <| toPagePath group (Tuple.first sub)
                    , class "hover:text-red-600"
                    , css [ marginLeft (px 6) ]
                    , classList
                        [ ( "text-red-700 font-bold", isActive )
                        , ( "text-blue-400", not isActive )
                        ]
                    ]
                    [ text <| Tuple.first sub ]
                , div
                    [ class "absolute bottom-0"
                    , css
                        [ marginLeft (px -24)
                        , width (px 26)
                        ]
                    ]
                    [ if isActive then
                        sick

                      else
                        text ""
                    ]
                ]
    in
    ul [ class "p-4 h-full overflow-scroll" ] <|
        List.map toPageMenu
            pages
