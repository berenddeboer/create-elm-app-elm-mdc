module Backend.API exposing (get)


import Http
import Json.Decode as Decode exposing (Decoder)

import Backend.Endpoint as Endpoint exposing (Endpoint)


-- HTTP

get : Endpoint -> (Result Http.Error a -> msg) -> Decoder a -> Cmd msg
get url msg decoder =
    Endpoint.request
        { method = "GET"
        , url = url
        , expect = Http.expectJson msg decoder
        , headers = []
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }
