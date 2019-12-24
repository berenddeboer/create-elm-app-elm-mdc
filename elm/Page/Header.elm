module Page.Header exposing
    ( menu
    , scrim
    , view
    )

import Html exposing (Html, text, h3, p)

import Material
import Material.Drawer.Modal as Drawer
import Material.List as Lists
import Material.Options as Options exposing (aria, styled, when)
import Material.TopAppBar as TopAppBar

import Page exposing (Page)
import Route exposing (Route)
import Session exposing (Msg(..), Session)


menuItems : List ( Route, String )
menuItems =
    [ ( Route.Hello, "Hello" )
    , ( Route.Articles, "Articles" )
    , ( Route.Logout, "Logout" )
    ]


menu : Session -> Page -> Html Session.Msg
menu session page =
    let
        listItem ( url, text ) =
            if text == "" then
                Lists.hr [] []
            else
                drawerLink page url text
    in
    Drawer.view Mdc
        "drawer"
        session.mdc
        [ Drawer.open |> when session.isDrawerOpen
        , Drawer.onClose CloseDrawer
        ]
        [ Drawer.header
            []
            [ styled h3 [ Drawer.title ] [ text "My menu" ]
            ]
        , Drawer.content []
            [ Lists.nav Mdc "drawer" session.mdc
                  [ Lists.singleSelection
                  , Lists.useActivated
                  ]
                  ( List.map listItem menuItems )
            ]
        ]


drawerLink : Page -> Route -> String -> Lists.ListItem msg
drawerLink page route linkContent =
    Lists.a
        [ Options.attribute (Route.href route)
        , Lists.activated |> when (isActive page route)
        ]
    [ text linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Page.Hello _, Route.Hello ) ->
            True
        ( Page.Articles _, Route.Articles ) ->
            True
        _ ->
            False


scrim : Html Session.Msg
scrim =
    Drawer.scrim [ Options.onClick CloseDrawer ] []


view : Session -> Html Session.Msg
view session =
    TopAppBar.view Session.Mdc
        "top-app-bar"
        session.mdc
        [ TopAppBar.fixed ]
        [ TopAppBar.section [ TopAppBar.alignStart ]
              [ TopAppBar.navigationIcon
                    Session.Mdc
                    "topappbar-menu"
                    session.mdc
                    [ Options.onClick OpenDrawer
                    , aria "expanded" (if session.isDrawerOpen then "true" else "false")
                    ]
                    "menu"
              , TopAppBar.title
                  []
                  [ text session.title ]
              ]
        ]
