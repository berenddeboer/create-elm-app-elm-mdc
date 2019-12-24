module Page exposing
    ( Page(..)
    )


import Page.Hello
import Page.Articles
import Page.Article

type Page
    = Loading
    | Hello Page.Hello.Model
    | Articles Page.Articles.Model
    | Article Page.Article.Model
