module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, text, div, main_, p)
import Html.Attributes exposing (class)
import Material.Options as Options exposing (styled)
import Material.TopAppBar as TopAppBar
import Url exposing (Url)

import Helpers
import Page exposing (Page(..))
import Page.Header
import Page.Hello
import Page.Article
import Page.Articles
import Route exposing (Route)
import Session exposing (Session)


-- MODEL

type alias Model =
    { page : Page
    , currentRoute : Maybe Route
    , key : Navigation.Key
    , session : Session
    }



init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( session, sessionCmd ) = Session.init
        ( model, cmd ) =
            setRoute (Route.fromUrl url)
                { page = Loading
                , currentRoute = Nothing
                , key = key
                , session = session
                }
    in
        ( model, Cmd.batch [ Cmd.map SessionMsg sessionCmd, cmd ] )



-- UPDATE

type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | SubPage PageMsg
    | SessionMsg Session.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubPage subMsg ->
            updatePage model.key subMsg model

        ChangedUrl url ->
            setRoute (Route.fromUrl url) model

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
                            let
                                session = model.session

                                newSession = { session | isDrawerOpen = False }
                            in
                            ( { model | session = newSession }
                            , Navigation.pushUrl model.key (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Navigation.load href
                    )

        SessionMsg subMsg ->
            updateSession subMsg model



updateSession : Session.Msg -> Model -> ( Model, Cmd Msg )
updateSession msg model =
    let
        ( newSession, cmd ) = Session.update msg model.session
    in
        ( { model | session = newSession }, Cmd.map SessionMsg cmd )


type PageMsg
    = HelloMsg Page.Hello.Msg
    | ArticlesMsg Page.Articles.Msg
    | ArticleMsg Page.Article.Msg


updatePage : Navigation.Key -> PageMsg -> Model -> ( Model, Cmd Msg )
updatePage key msg model =
    let
        executeSessionMsg sessionMsg =
            sessionMsg
                |> Maybe.map (\s -> Session.update s model.session)
                |> Maybe.withDefault ( model.session, Cmd.none )

        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd, sessionMsg ) =
                    subUpdate subMsg subModel
                ( newSession, newSessionCmd ) =
                    executeSessionMsg sessionMsg
            in
            ( { model
                | page = toModel newModel
                , session = newSession
              }
            , Cmd.batch [ Cmd.map SessionMsg newSessionCmd, Cmd.map (SubPage << toMsg) newCmd ]
            )
    in
    case ( msg, model.page ) of
        ( HelloMsg subMsg, Hello subModel ) ->
            toPage Hello HelloMsg Page.Hello.update subMsg subModel

        ( ArticlesMsg subMsg, Articles subModel ) ->
            toPage Articles ArticlesMsg Page.Articles.update subMsg subModel

        ( ArticleMsg subMsg, Article subModel ) ->
            toPage Article ArticleMsg Page.Article.update subMsg subModel

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        header =
            let
                sessionHeader = Page.Header.view model.session
            in
                Html.map SessionMsg sessionHeader

        menu =
            let
                sessionMenu = Page.Header.menu model.session model.page
            in
                Html.map SessionMsg sessionMenu

        scrim =
            let
                sessionScrim = Page.Header.scrim
            in
                Html.map SessionMsg sessionScrim

        page =
            case model.page of
                Loading ->
                    p [] [ text "Loading" ]

                Hello subModel ->
                    Page.Hello.view subModel
                        |> Html.map (SubPage << HelloMsg)

                Articles subModel ->
                    Page.Articles.view subModel
                        |> Html.map (SubPage << ArticlesMsg)

                Article subModel ->
                    Page.Article.view subModel
                        |> Html.map (SubPage << ArticleMsg)

    in
    Browser.Document model.session.title
        [ div [ class "mdc-typography" ]
              [ header
              , menu
              , scrim
              , styled main_
                  [ TopAppBar.fixedAdjust ]
                  [ page ]
              ]
        ]


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition page pageMsg cmd =
            ( { model | page = page, currentRoute = maybeRoute }, toSubPageMsg pageMsg cmd )
    in
    if model.currentRoute == maybeRoute then
        ( model, Cmd.none )

    else
        case maybeRoute of
            Just route ->
                case route of
                    Route.Hello ->
                        let
                            ( page, cmd ) = Page.Hello.init model.session
                        in
                            transition (Hello page) HelloMsg cmd

                    Route.Articles ->
                        let
                            ( page, msg ) = Page.Articles.init model.session
                        in
                            transition (Articles page) ArticlesMsg (Helpers.cmd msg)

                    Route.Article uuid ->
                        let
                            ( page, msg ) = Page.Article.init model.session uuid
                        in
                            transition (Article page) ArticleMsg (Helpers.cmd msg)

                    Route.Logout ->
                        ( model, Cmd.none )

            Nothing ->
                ( model, Cmd.none )


toSubPageMsg pageMsg cmd =
    Cmd.map SubPage (Cmd.map pageMsg cmd)


-- MAIN

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , view = view
        , update = update
        , subscriptions = \a -> Sub.none
        }
