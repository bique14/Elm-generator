module Stories exposing (Story)

import Html.Styled exposing (Html)


type alias Story msg =
    ( String, List ( String, Html msg ) )
