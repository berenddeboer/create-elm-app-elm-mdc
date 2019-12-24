module Page.Hello exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Browser.Navigation as Navigation
import Html exposing (Html, text)

import Material
import Material.Button as Button
import Material.LayoutGrid as LayoutGrid exposing (cell, span1Phone, span2Phone)
import Material.Options as Options exposing (styled, cs, css)
import Material.Snackbar as Snackbar
import Material.TopAppBar as TopAppBar

import Session exposing (Msg(..), Session)



-- MODEL

type alias Model =
    { mdc : Material.Model Msg
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg
    = Mdc (Material.Msg Msg)
    | Click


init : Session -> ( Model, Cmd Msg )
init session =
    ( defaultModel, Material.init Mdc )



-- UPDATE

subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Session.Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            let
                ( newModel, cmdMsg) = Material.update Mdc msg_ model
            in
                ( newModel, cmdMsg, Nothing )

        Click ->
            toast model "You clicked me!"


{-| Helper function to show a toast message.
-}
toast : Model -> String -> ( Model, Cmd Msg, Maybe Session.Msg )
toast model message =
    let
        contents =
            Snackbar.toast Nothing message
        ( mdc, effects ) =
            Snackbar.add Mdc "my-snackbar" contents model.mdc
    in
        ( { model | mdc = mdc }
        , effects
        , Nothing
        )




-- VIEW

view : Model -> Html Msg
view model =
    LayoutGrid.view [ TopAppBar.fixedAdjust ]
        [ cell [ span1Phone ] []
        , cell [ span2Phone, css "padding-top" "1em" ]
            [ Button.view Mdc
                  "my-button"
                  model.mdc
                  [ Button.ripple
                  , Button.raised
                  , Options.onClick Click
                  ]
                  [ text "Click me!" ]
            , viewSnackbar model
            ]
        , cell [span1Phone ] []
        ]


viewSnackbar : Model -> Html Msg
viewSnackbar model =
    Snackbar.view Mdc "my-snackbar" model.mdc [] []
