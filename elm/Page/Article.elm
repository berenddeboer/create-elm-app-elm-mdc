module Page.Article exposing
    ( Model
    , Msg
    , init
    , view
    , update
    )


import Html exposing (Html, text, div, p)
import Http
import RemoteData exposing (RemoteData(..), WebData)

import Backend.Endpoint as Endpoint
import Backend.API as API
import JsonApi.Article as JsonApi
import Session exposing (Session)
import WebDataView


-- MODEL

type alias Model =
    { article : WebData JsonApi.Article
    }


defaultModel : Model
defaultModel =
    { article = NotAsked
    }


init : Session -> String -> ( Model, Msg )
init session uuid =
    ( defaultModel, GetArticle uuid )



-- UPDATE

type Msg
    = GetArticle String
    | GotArticle (WebData JsonApi.Article)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Session.Msg )
update msg model =
    case msg of
        GetArticle uuid ->
            ( { model | article = Loading }, getArticle uuid, Nothing )

        GotArticle response ->
            ( { model | article = response }, Cmd.none, Nothing )




-- VIEW

view : Model -> Html msg
view model =
  WebDataView.view viewArticle model.article


viewArticle : JsonApi.Article -> Html msg
viewArticle article =
    p [] [ text article.data.attributes.body.processed ]


-- FETCH

getArticle uuid =
    API.get (Endpoint.article uuid) (RemoteData.fromResult >> GotArticle) JsonApi.decodeArticle
