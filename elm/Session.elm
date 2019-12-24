module Session exposing
    ( Msg(..)
    , Session
    , init
    , update
    , subscriptions
    )


import Material


type Msg
    = Mdc (Material.Msg Msg)
    | OpenDrawer
    | CloseDrawer


type alias Session =
    { mdc : Material.Model Msg
    , title : String
    , isDrawerOpen : Bool
    }


defaultSession =
    { mdc = Material.defaultModel
    , title = "Example"
    , isDrawerOpen = False
    }


init : ( Session, Cmd Msg )
init =
    ( defaultSession, Material.init Mdc )


update : Msg -> Session -> ( Session, Cmd Msg )
update msg session =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ session

        OpenDrawer ->
            ( { session | isDrawerOpen = True }, Cmd.none )

        CloseDrawer ->
            ( { session | isDrawerOpen = False }, Cmd.none )


subscriptions : Session -> Sub Msg
subscriptions session =
    Material.subscriptions Mdc session
