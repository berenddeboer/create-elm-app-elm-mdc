module Page.Articles exposing
    ( Model
    , Msg
    , init
    , view
    , update
    )


import Html exposing (Html, text, a, div, p)
import Http
import RemoteData exposing (RemoteData(..), WebData)

import Backend.Endpoint as Endpoint
import Backend.API as API
import JsonApi.Article as JsonApi
import Route
import Session exposing (Session)
import WebDataView


-- MODEL

type alias Model =
    { articles : WebData JsonApi.Articles
    }


defaultModel : Model
defaultModel =
    { articles = NotAsked
    }


init : Session -> ( Model, Msg )
init session =
    ( defaultModel, GetArticles )



-- UPDATE

type Msg
    = GetArticles
    | GotArticles (WebData JsonApi.Articles)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Session.Msg )
update msg model =
    case msg of
        GetArticles ->
            ( { model | articles = Loading }, getArticles, Nothing )

        GotArticles response ->
            ( { model | articles = response }, Cmd.none, Nothing )




-- VIEW

view : Model -> Html msg
view model =
  WebDataView.view viewArticles model.articles


viewArticles : JsonApi.Articles -> Html msg
viewArticles articles =
    div []
        ( List.map
              (\item ->
                   p []
                   [ a [ Route.href ( Route.Article item.id ) ]
                         [ text item.attributes.title ]
                   ]
              )
              articles.data
        )





-- FETCH

getArticles =
    API.get Endpoint.articles (RemoteData.fromResult >> GotArticles) JsonApi.decodeArticles
