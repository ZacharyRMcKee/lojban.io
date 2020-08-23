{-# LANGUAGE OverloadedStrings #-}

module Server.Website.Main
( handleRoot
) where

import Core
import Serializer (exerciseToJSON, validateExerciseAnswer)
import qualified Courses.English.Grammar.Introduction.Course
import qualified Courses.English.Grammar.Crash.Course
import qualified Courses.English.Vocabulary.Attitudinals.Course
import qualified Courses.English.Vocabulary.Brivla.Course
import qualified Decks.English.ContextualizedBrivla
import Server.Core
import Server.Util (forceSlash, getBody)
import Server.Website.Views.Core
import Server.Website.Views.Home (displayHome)
import Server.Website.Views.Courses (displayCoursesHome)
import Server.Website.Views.Decks (displayDecksHome)
import Server.Website.Views.Deck (displayDeckHome, displayDeckExercise)
import Server.Website.Views.Grammar (displayGrammarHome)
import Server.Website.Views.Vocabulary (displayVocabularyHome)
import Server.Website.Views.Resources (displayResourcesHome)
import Server.Website.Views.Offline (displayOfflineHome)
import Server.Website.Views.Course (displayCourseHome)
import Server.Website.Views.Lesson (displayLessonHome, displayLessonExercise)
import Control.Monad (msum, guard)
import Control.Monad.IO.Class (liftIO)
import System.Random (newStdGen, mkStdGen)
import qualified Server.OAuth2.Main as OAuth2
import qualified Data.Aeson as A
import qualified Data.Text as T
import Happstack.Server

-- TODO: consider adding breadcrumbs (https://getbootstrap.com/docs/4.0/components/breadcrumb/)

-- * Handlers
handleRoot :: ServerConfiguration -> ServerResources -> ServerPart Response
handleRoot serverConfiguration serverResources = do
    userIdentityMaybe <- OAuth2.readUserIdentityFromCookies serverConfiguration serverResources
    msum
        [ forceSlash $ handleHome userIdentityMaybe
        , dir "courses" $ handleCourses userIdentityMaybe
        , dir "decks" $ handleDecks serverConfiguration serverResources userIdentityMaybe
        , dir "grammar" $ handleGrammar userIdentityMaybe
        , dir "vocabulary" $ handleVocabulary userIdentityMaybe
        , dir "resources" $ handleResources userIdentityMaybe
        , dir "offline" $ handleOffline userIdentityMaybe
        ]

handleHome :: Maybe UserIdentity -> ServerPart Response
handleHome userIdentityMaybe = ok . toResponse $ displayHome userIdentityMaybe

handleCourses :: Maybe UserIdentity -> ServerPart Response
handleCourses userIdentityMaybe = msum
    [ forceSlash . ok . toResponse $ displayCoursesHome userIdentityMaybe
    , dir "introduction" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Grammar.Introduction.Course.course
    , dir "crash" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Grammar.Crash.Course.course
    , dir "attitudinals" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Vocabulary.Attitudinals.Course.course
    , dir "brivla" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Vocabulary.Brivla.Course.course
    ]

handleDecks :: ServerConfiguration -> ServerResources -> Maybe UserIdentity -> ServerPart Response
handleDecks serverConfiguration serverResources userIdentityMaybe = msum
    [ forceSlash . ok . toResponse $ displayDecksHome userIdentityMaybe
    , dir "contextualized-brivla" $ handleDeck serverConfiguration serverResources userIdentityMaybe Decks.English.ContextualizedBrivla.deck
    ]

handleGrammar :: Maybe UserIdentity -> ServerPart Response
handleGrammar userIdentityMaybe = msum
    [ forceSlash . ok . toResponse $ displayGrammarHome userIdentityMaybe
    , dir "introduction" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Grammar.Introduction.Course.course
    , dir "crash" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Grammar.Crash.Course.course
    ]

handleVocabulary :: Maybe UserIdentity -> ServerPart Response
handleVocabulary userIdentityMaybe = msum
    [ forceSlash . ok . toResponse $ displayVocabularyHome userIdentityMaybe
    , dir "attitudinals" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Vocabulary.Attitudinals.Course.course
    , dir "brivla" $ handleCourse userIdentityMaybe TopbarCourses Courses.English.Vocabulary.Brivla.Course.course
    ]

handleResources :: Maybe UserIdentity -> ServerPart Response
handleResources userIdentityMaybe = msum
    [ forceSlash . ok . toResponse $ displayResourcesHome userIdentityMaybe
    ]

handleOffline :: Maybe UserIdentity -> ServerPart Response
handleOffline userIdentityMaybe = msum
    [ forceSlash . ok . toResponse $ displayOfflineHome userIdentityMaybe
    ]

handleCourse :: Maybe UserIdentity -> TopbarCategory -> Course -> ServerPart Response
handleCourse userIdentityMaybe topbarCategory course =
    let lessons = courseLessons course
    in msum
        [ forceSlash . ok . toResponse . displayCourseHome userIdentityMaybe topbarCategory $ course
        , path $ \n -> (guard $ 1 <= n && n <= (length lessons)) >> (handleLesson userIdentityMaybe topbarCategory course n)
        ]

handleDeck :: ServerConfiguration -> ServerResources -> Maybe UserIdentity -> Deck -> ServerPart Response
handleDeck serverConfiguration serverResources userIdentityMaybe deck = msum
    [ forceSlash . ok . toResponse $ displayDeckHome userIdentityMaybe deck
    , dir "exercises" $ do
        identityMaybe <- OAuth2.readUserIdentityFromCookies serverConfiguration serverResources
        case identityMaybe of
            Nothing -> do
                --tempRedirect ("./" :: T.Text) . toResponse $ ("You must be signed in." :: T.Text)
                ok . toResponse $ includeInlineScript ("alert('To practice with decks, you need to sign in.'); window.location.href='./';" :: T.Text)
            Just identity -> ok . toResponse $ displayDeckExercise userIdentityMaybe deck
    ]

handleLesson :: Maybe UserIdentity -> TopbarCategory -> Course -> Int -> ServerPart Response
handleLesson userIdentityMaybe topbarCategory course lessonNumber = msum
    [ forceSlash . ok . toResponse $ displayLessonHome userIdentityMaybe topbarCategory course lessonNumber
    , dir "exercises" $ msum
        [ forceSlash . ok . toResponse $ displayLessonExercise userIdentityMaybe topbarCategory course lessonNumber
        , path $ \n ->
            let
                lesson = (courseLessons course) !! (lessonNumber - 1)
                exercise = lessonExercises lesson (mkStdGen n)
            in msum
                [ dir "get" $ (liftIO $ newStdGen) >>= ok . toResponse . A.encode . exerciseToJSON exercise
                , dir "submit" $ getBody >>= \body -> ok . toResponse . A.encode . A.object $
                    case validateExerciseAnswer exercise body of
                        Nothing -> [("success", A.Bool False)]
                        Just data' -> [("success", A.Bool True), ("data", data')]
                ]
        ]
    ]
