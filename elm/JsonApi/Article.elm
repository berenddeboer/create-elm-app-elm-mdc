module JsonApi.Article exposing (..)


import Json.Encode
import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)

type alias Articles =
    { jsonapi : ArticleJsonapi
    , data : List Data
    , links : ArticleLinks
    }

type alias Article =
    { jsonapi : ArticleJsonapi
    , data : Data
    , links : ArticleLinks
    }

type alias ArticleJsonapiMetaLinksSelf =
    { href : String
    }

type alias ArticleJsonapiMetaLinks =
    { self : ArticleJsonapiMetaLinksSelf
    }

type alias ArticleJsonapiMeta =
    { links : ArticleJsonapiMetaLinks
    }

type alias ArticleJsonapi =
    { version : String
    , meta : ArticleJsonapiMeta
    }

type alias ArticleLinksSelf =
    { href : String
    }

type alias Data =
    { type_ : String
    , id : String
    , attributes : Attributes
    }

type alias Attributes =
    { drupal_internal_nid : Int
    , title : String
    , body : Body
    }

type alias Body =
    { processed : String
    }

type alias ArticleLinks =
    { self : ArticleLinksSelf
    }

decodeArticles : Decoder Articles
decodeArticles =
    Decode.succeed Articles
        |> required "jsonapi" decodeArticleJsonapi
        |> required "data" (Decode.list decodeData)
        |> required "links" decodeArticleLinks

decodeArticle : Decoder Article
decodeArticle =
    Decode.succeed Article
        |> required "jsonapi" decodeArticleJsonapi
        |> required "data" decodeData
        |> required "links" decodeArticleLinks

decodeArticleJsonapiMetaLinksSelf : Decoder ArticleJsonapiMetaLinksSelf
decodeArticleJsonapiMetaLinksSelf =
    Decode.succeed ArticleJsonapiMetaLinksSelf
        |> required "href" string

decodeArticleJsonapiMetaLinks : Decoder ArticleJsonapiMetaLinks
decodeArticleJsonapiMetaLinks =
    Decode.succeed ArticleJsonapiMetaLinks
        |> required "self" (decodeArticleJsonapiMetaLinksSelf)

decodeArticleJsonapiMeta : Decoder ArticleJsonapiMeta
decodeArticleJsonapiMeta =
    Decode.succeed ArticleJsonapiMeta
        |> required "links" (decodeArticleJsonapiMetaLinks)

decodeArticleJsonapi : Decoder ArticleJsonapi
decodeArticleJsonapi =
    Decode.succeed ArticleJsonapi
        |> required "version" string
        |> required "meta" (decodeArticleJsonapiMeta)

decodeArticleLinksSelf : Decoder ArticleLinksSelf
decodeArticleLinksSelf =
    Decode.succeed ArticleLinksSelf
        |> required "href" string

decodeData : Decoder Data
decodeData =
    Decode.succeed Data
        |> required "type" string
        |> required "id" string
        |> required "attributes" decodeAttributes

decodeAttributes : Decoder Attributes
decodeAttributes =
    Decode.succeed Attributes
        |> required "drupal_internal__nid" int
        |> required "title" string
        |> required "body" decodeBody

decodeBody : Decoder Body
decodeBody =
    Decode.succeed Body
        |> required "processed" string

decodeArticleLinks : Decoder ArticleLinks
decodeArticleLinks =
    Decode.succeed ArticleLinks
        |> required "self" (decodeArticleLinksSelf)
