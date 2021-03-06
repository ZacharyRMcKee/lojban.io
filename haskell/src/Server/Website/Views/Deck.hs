{-# LANGUAGE OverloadedStrings #-}

module Server.Website.Views.Deck
( displayDeckHome
, displayDeckExercise
) where

import Core
import Server.Core
import Server.Website.Views.Core
import Control.Monad (when)
import Data.Maybe (isJust, fromJust)
import Data.Either.Unwrap (fromRight)
import qualified Data.Text as T
import qualified Text.Pandoc as P
import qualified Text.Pandoc.Writers.HTML as PWH
import qualified Text.Blaze as B
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

-- TODO: consider using list groups (https://getbootstrap.com/docs/4.0/components/list-group/)
displayDeckHome :: ServerConfiguration -> Maybe UserIdentity -> Deck -> H.Html
displayDeckHome serverConfiguration userIdentityMaybe deck = do
    let baseDeckUrl = ""
    let title = deckTitle deck
    let shortDescription = deckShortDescription deck
    H.docType
    H.html B.! A.lang (H.stringValue "en-us") $ do
        H.head $ do
            H.title $ H.toHtml (title `T.append` " :: lojban.io")
            H.meta B.! A.name (H.textValue "description") B.! A.content (H.textValue shortDescription)
            includeUniversalStylesheets
            includeUniversalScripts
            includeInternalStylesheet "deck.css"
            includeDeckScript deck
            includeInternalScript "deck-min.js"
        H.body $ do
            displayTopbar serverConfiguration userIdentityMaybe TopbarDecks
            H.div B.! A.class_ (H.stringValue "main") $ do
                H.div B.! A.class_ (H.textValue "header") $ do
                    H.div B.! A.class_ (H.textValue "header-bg") $ H.toHtml ("" :: T.Text)
                    displayDeckHomeHeader baseDeckUrl deck
                H.div B.! A.class_ (H.textValue "body") $ do
                    H.div B.! A.class_ (H.textValue "deck-contents") $ do
                        when (isJust $ deckLongDescription deck) $ do
                            H.div B.! A.class_ (H.stringValue "deck-about") $ do
                                H.h2 $ H.toHtml ("About this deck" :: String)
                                H.div $ do
                                    fromRight . P.runPure . PWH.writeHtml5 P.def $ fromJust (deckLongDescription deck)
                        H.div B.! A.class_ (H.stringValue "deck-manage") $ do
                            H.h2 $ H.toHtml ("Manage your cards" :: T.Text)
                            H.p $ H.toHtml ("Tap on cards to alternate between \"not started\" (or \"inactive\"), \"currently learning\" and \"already mastered\"." `T.append`
                                            " Stars represent how familiar you are with each card, based on past performance." `T.append`
                                            " Only cards tagged as \"currently learning\" will appear in exercises." `T.append`
                                            " Consequently, once you have mastered a card, you may optionally tag it as \"already mastered\" to ignore it." :: T.Text)
                            H.p $ H.toHtml ("For the optimal learning experience, we suggest having between 10 and 200 active cards at any given moment." `T.append`
                                            " Cards for exercises are selected algorithmically, in such a way that lesser-known cards are featured more frequently." :: T.Text)
                            H.div B.! A.class_ (H.stringValue "deck-cards") $ H.toHtml ("" :: T.Text)
                        when (isJust $ deckCredits deck) $ do
                            H.div B.! A.class_ (H.stringValue "deck-credits") $ do
                                H.h2 $ H.toHtml ("Credits" :: String)
                                H.div $ do
                                    fromRight . P.runPure . PWH.writeHtml5 P.def $ fromJust (deckCredits deck)
                    displayFooter

displayDeckExercise :: ServerConfiguration -> Maybe UserIdentity -> Deck -> H.Html
displayDeckExercise serverConfiguration userIdentityMaybe deck = do
    let dictionary = deckDictionary deck
    let baseDeckUrl = "./"
    H.docType
    H.html $ do
        H.head $ do
            H.title (H.toHtml $ (deckTitle deck) `T.append` " :: Practice :: lojban.io")
            includeUniversalStylesheets
            includeInternalStylesheet "funkyradio.css"
            includeInternalStylesheet "list-group-horizontal.css"
            includeInternalStylesheet "exercise.css"
            includeUniversalScripts
            includeDictionaryScript dictionary
            includeDeckScript deck
            includeInternalScript "exercise-min.js"
        H.body $ do
            displayTopbar serverConfiguration userIdentityMaybe TopbarDecks
            H.div B.! A.class_ (H.stringValue "main") $ do
                H.div B.! A.class_ (H.textValue "body") $ do
                    displayDeckExerciseHeader baseDeckUrl deck
                    H.div B.! A.class_ (H.stringValue "deck") $ do
                        H.div B.! A.id (H.stringValue "exercise-holder") $ H.toHtml ("" :: T.Text)

displayDeckHomeHeader :: T.Text -> Deck -> H.Html
displayDeckHomeHeader baseDeckUrl deck = do
    let title = deckTitle deck
    let shortDescription = deckShortDescription deck
    H.div B.! A.class_ (H.stringValue "deck-header") $ do
        H.div B.! A.class_ (H.stringValue "deck-info") $ do
            H.div B.! A.class_ (H.stringValue "deck-info-short") $ do
                H.h1 B.! A.class_ "deck-title" $ H.toHtml title
                H.h1 B.! A.class_ "deck-cards-count" $ H.toHtml (showNumberOfCards . length . deckCards $ deck)
            H.p B.! A.class_ "deck-description" $ H.toHtml shortDescription
        H.div B.! A.class_ "deck-buttons" $ do
            H.a B.! A.class_ (H.textValue "button") B.! A.href (H.textValue $ baseDeckUrl `T.append` "./exercises") $ (H.toHtml ("Practice" :: T.Text))

displayDeckExerciseHeader :: T.Text -> Deck -> H.Html
displayDeckExerciseHeader baseDeckUrl deck = do
    -- TODO: consider displaying: "x active cards out of y"
    let cardsCount = length (deckCards deck)
    H.div B.! A.class_ (H.stringValue "deck-header") $ do
        H.div B.! A.class_ (H.stringValue "deck-info") $ do
            H.h1 B.! A.class_ "deck-title" $
                H.a B.! A.href (H.textValue baseDeckUrl) $ H.toHtml (deckTitle deck)
        H.div B.! A.class_ "deck-buttons" $ do
            H.a B.! A.class_ (H.textValue "button") B.! A.href (H.textValue baseDeckUrl) $ (H.toHtml ("Review Deck" :: T.Text))

showNumberOfCards :: Int -> String
showNumberOfCards 0 = "No cards yet..."
showNumberOfCards 1 = "1 card"
showNumberOfCards x = (show x) ++ " cards"
