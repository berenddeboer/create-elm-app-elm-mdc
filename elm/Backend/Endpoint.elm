module Backend.Endpoint exposing
    ( Endpoint
    , request
    , articles
    , article
    )


{-| Module that has the full list of endpoints, API urls, this app knows about.
-}

import Http
import Url.Builder exposing (QueryParameter, string)


{-| Http.request, except it takes an Endpoint instead of a Url.
-}
request :
    { method : String
    , headers : List Http.Header
    , url : Endpoint
    , body : Http.Body
    , expect : Http.Expect msg
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd msg
request config =
    Http.request
        { method = config.method
        , headers = config.headers
        , url = "http://drupal8-elm-meetup.local/" ++ unwrap config.url ++ "?_format=api_json"
        , body = config.body
        , expect = config.expect
        , timeout = config.timeout
        , tracker = config.tracker
        }



-- TYPES


{-| Get a URL to our GraphSQL API.

This is not publicly exposed, because we want to make sure the only way to get one of these URLs is from this module.

-}
type Endpoint
    = Endpoint String


unwrap : Endpoint -> String
unwrap (Endpoint str) =
    str


url : List String -> List QueryParameter -> Endpoint
url paths queryParams =
    -- NOTE: Url.Builder takes care of percent-encoding special URL characters.
    -- See https://package.elm-lang.org/packages/elm/url/latest/Url#percentEncode
    Url.Builder.relative
        paths
        queryParams
        |> Endpoint



-- ENDPOINTS


articles : Endpoint
articles =
    url [ "jsonapi", "node", "article" ] []


article : String -> Endpoint
article uuid =
    url [ "jsonapi", "node", "article", uuid ] []
