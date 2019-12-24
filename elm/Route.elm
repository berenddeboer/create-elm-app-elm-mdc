module Route exposing
    ( Route(..)
    , href
    , fromUrl
    , pushUrl
    , replaceUrl
    )

import Browser.Navigation as Navigation
import Html exposing (Attribute)
import Html.Attributes as Attributes
import List.Extra
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), Parser, int, string, oneOf, s)


type Route
    = Hello
    | Articles
    | Article String
    | Logout


{-| Parse a fragment, a string, into a `Route`.
-}
route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Hello (s "hello")
        , Url.map Articles (s "articles")
        , Url.map Article (s "article" </> string)
        ]


{-| Convert a `Route` into a string.
-}
toString : Route -> String
toString rt =
    let
        pieces =
            case rt of
                Hello ->
                    [ "hello" ]
                Articles ->
                    [ "articles" ]
                Article uuid ->
                    [ "article", uuid ]
                Logout ->
                    [ "logout" ]

    in
    "#/" ++ String.join "/" pieces


href : Route -> Attribute msg
href targetRoute =
    Attributes.href (toString targetRoute)


fromUrl : Url -> Maybe Route
fromUrl url =
    let
        fragment =
            Maybe.withDefault "" url.fragment
    in
    if String.isEmpty fragment then
        Just Hello

    else
        let
            elements =
                String.split "?" fragment
        in
        Url.parse route
            { url
                | query = Just <| (Maybe.withDefault "" <| List.Extra.last elements)
                , path = Maybe.withDefault "" <| List.head elements
                , fragment = Nothing
            }


pushUrl : Navigation.Key -> Route -> Cmd msg
pushUrl key =
    toString >> Navigation.pushUrl key


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key =
    toString >> Navigation.replaceUrl key
