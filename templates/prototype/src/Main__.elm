module Main__ exposing (main)

import Browser
import Browser.Navigation as Nav
import Components.AdSpace as AdSpace
import Flows.CreateCampaign as FlowCreateCampaign
import Html exposing (Html)
import Url


type alias Model =
    { flow : Flow
    , createCampaign : FlowCreateCampaign.Model
    }


type Flow
    = CreateCampaign


type Msg
    = FlowCreateCampaignMsg FlowCreateCampaign.Msg
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FlowCreateCampaignMsg msg_ ->
            let
                updatedModel =
                    FlowCreateCampaign.update msg_ model.createCampaign
            in
            ( { model | createCampaign = updatedModel }, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )

        UrlRequested url ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Prototype | Campaign Management"
    , body =
        [ Html.map FlowCreateCampaignMsg
            (FlowCreateCampaign.view model.createCampaign)
        ]
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { flow = CreateCampaign
      , createCampaign =
            { page = FlowCreateCampaign.CampaignsList
            , previousPage = FlowCreateCampaign.Unsupported
            , adSpace = AdSpace.init
            }
      }
    , Cmd.none
    )


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
