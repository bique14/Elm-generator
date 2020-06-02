module Route exposing (Route(..), fromUrl)

import Url
import Url.Parser exposing ((</>), Parser, oneOf, s, string)


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map Components (s "component" </> string)
        , Url.Parser.map Page (s "page" </> string)
        ]


type Route
    = Home
    | Components String
    | Page String


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    Url.Parser.parse parser url
