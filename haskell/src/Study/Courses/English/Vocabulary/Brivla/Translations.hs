{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

-- | This module defines translations for the course.
module Study.Courses.English.Vocabulary.Brivla.Translations where

import Core
import Study.Framework.TranslationLoaders (loadTranslationsByExpressionFromYamlCode)
import Data.FileEmbed (embedStringFile)

-- | Translations for the corresponding lesson.
translationsByExpression01 :: TranslationsByExpression
translationsByExpression01 = loadTranslationsByExpressionFromYamlCode $(embedStringFile "resources/decks/english/brivla/sentences/01.yaml")

-- | Translations for the corresponding lesson.
translationsByExpression02 :: TranslationsByExpression
translationsByExpression02 = loadTranslationsByExpressionFromYamlCode $(embedStringFile "resources/decks/english/brivla/sentences/02.yaml")

-- | Translations for the corresponding lesson.
translationsByExpression03 :: TranslationsByExpression
translationsByExpression03 = loadTranslationsByExpressionFromYamlCode $(embedStringFile "resources/decks/english/brivla/sentences/03.yaml")

-- | Translations for the corresponding lesson.
translationsByExpression04 :: TranslationsByExpression
translationsByExpression04 = loadTranslationsByExpressionFromYamlCode $(embedStringFile "resources/decks/english/brivla/sentences/04.yaml")

-- | Translations for the corresponding lesson.
translationsByExpression05 :: TranslationsByExpression
translationsByExpression05 = loadTranslationsByExpressionFromYamlCode $(embedStringFile "resources/decks/english/brivla/sentences/05.yaml")

-- | All translations.
translationsByExpression :: TranslationsByExpression
translationsByExpression = mconcat [translationsByExpression01, translationsByExpression02, translationsByExpression03, translationsByExpression04, translationsByExpression05]
