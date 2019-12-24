module WebDataView exposing (view)


import Html exposing (Html, text, p)
import Http
import RemoteData exposing (RemoteData(..), WebData)


view : ( a -> Html msg ) -> WebData a -> Html msg
view successView webData =
    case webData of
        NotAsked ->
            p [] [ text ""]

        Loading ->
            p [] [ text "Spinner here"]

        Failure (Http.BadStatus 404) ->
            p [] [ text "No data found."]

        Failure err ->
            p [] [ text ("Error: " ++ Debug.toString err) ]
            --p [] [ text "Some error occurred" ]

        Success response ->
            successView response
