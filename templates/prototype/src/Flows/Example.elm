module Flows.Example exposing
    ( Model
    , Msg
    , Page(..)
    , buildAdSpaceModel
    , update
    , view
    )

import Components.AdSpace as AdSpace
import Components.CampaignDetails as CampaignDetails
import Components.CampaignsList as CampaignsList
import Components.CreateCampaign as CreateCampaign
import Components.Header as Header
import Html exposing (..)
import Html.Styled exposing (toUnstyled)


type alias Model =
    { page : Page }


type Page
    = ExamplePage


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        _ ->
            model


view : Model -> Html Msg
view model =
    div [] [ text "Example" ]