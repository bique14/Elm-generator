module Stories.Example exposing
    ( Msg
    , pages
    )

import Html.Styled exposing (..)
import Stories exposing (Story)


pages : (Msg -> msg) -> List (Story msg)
pages msg =
    [ ( "Example"
      , [ ( "view", map msg view )
        ]
      )
    ]


type Msg
    = Log String


view : Html Msg
view =
    div [] [ text "This is a Storybook"]