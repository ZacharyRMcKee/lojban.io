{-# LANGUAGE OverloadedStrings #-}

module Courses.English.Grammar.Introduction.Exercises where

import Core
import Courses.Util.Vocabulary
import Courses.Util.ExerciseGenerators
import Language.Lojban.Presentation (displayStandardSimpleBridi, displayVariantSimpleBridi, displayReorderedStandardSimpleBridi)
import Language.Lojban.Refinement (simplifyTerminatorsInBridiDisplayer)
import Courses.English.Grammar.Introduction.Translations
import Courses.English.Grammar.Introduction.Vocabulary
import Util (combineFunctions, generatorFromWeightedList)

-------- Exercises
exercises1 :: Dictionary -> ExerciseGenerator
exercises1 dictionary =
    combineFunctions
        [ (20, generateGrammaticalClassExercise vocabulary)
        , (15, generateBridiJufraExercise vocabulary displayBridi)
        , (20, generateSelbriIdentificationExercise vocabulary displayBridi)
        , (10, generateContextualizedGismuPlacePositionExercise dictionary vocabulary displayBridi)
        , (20, generateContextualizedGismuPlaceMeaningExercise dictionary vocabulary displayBridi)
        , (40, translationExercises1)
        ]
    where
        vocabulary = vocabularyGenerator1 dictionary
        displayBridi = combineFunctions [(7, displayStandardSimpleBridi), (3, displayVariantSimpleBridi)]

exercises2 :: Dictionary -> ExerciseGenerator
exercises2 dictionary =
    combineFunctions
        [ (10, generateGrammaticalClassExercise vocabulary)
        , (10, generateBridiJufraExercise vocabulary displayBridi)
        , (10, generateSelbriIdentificationExercise vocabulary displayBridi)
        , (20, generateContextualizedGismuPlacePositionExercise dictionary vocabulary displayBridi)
        , (20, generateContextualizedGismuPlaceMeaningExercise dictionary vocabulary displayBridi)
        , (30, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions")
        , (60, translationExercises2)
        ]
    where
        vocabulary = vocabularyGenerator2 dictionary
        displayBridi = combineFunctions [(7, displayStandardSimpleBridi), (2, displayVariantSimpleBridi), (1, displayReorderedStandardSimpleBridi)]

exercises3 :: Dictionary -> ExerciseGenerator
exercises3 dictionary =
    combineFunctions
        [ (20, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions")
        , (20, generateContextualizedGismuPlaceMeaningExercise dictionary vocabulary displayBridi)
        , (20, questionExercises3)
        , (80, translationExercises3)
        ]
    where
        vocabulary = vocabularyGenerator3 dictionary
        displayBridi = combineFunctions [(7, displayStandardSimpleBridi), (2, displayVariantSimpleBridi), (1, displayReorderedStandardSimpleBridi)]

exercises4 :: Dictionary -> ExerciseGenerator
exercises4 dictionary =
    combineFunctions
        [ (30, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions")
        , (10, generateContextualizedGismuPlaceMeaningExercise dictionary vocabulary displayBridi)
        , (40, abstractionExercises4)
        , (70, translationExercises4)
        ]
    where
        vocabulary = vocabularyGenerator4 dictionary
        displayBridi = combineFunctions [(7, displayStandardSimpleBridi), (2, displayVariantSimpleBridi), (1, displayReorderedStandardSimpleBridi)]

exercises5 :: Dictionary -> ExerciseGenerator
exercises5 dictionary =
    combineFunctions
        [ (20, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions")
        , (10, generateContextualizedGismuPlaceMeaningExercise dictionary vocabulary displayBridi)
        , (70, translationExercises5_restricted)
        ]
    where
        vocabulary = vocabularyGenerator5 dictionary
        displayBridi = simplifyTerminatorsInBridiDisplayer $ (combineFunctions [(7, displayStandardSimpleBridi), (2, displayVariantSimpleBridi), (1, displayReorderedStandardSimpleBridi)])

exercises1to5 :: Dictionary -> ExerciseGenerator
exercises1to5 dictionary =
    combineFunctions
        [ (5, generateGrammaticalClassExercise vocabulary)
        , (5, generateBridiJufraExercise vocabulary displayBridi)
        , (5, generateSelbriIdentificationExercise vocabulary displayBridi)
        , (5, generateContextualizedGismuPlacePositionExercise dictionary vocabulary displayBridi)
        , (15, generateContextualizedGismuPlaceMeaningExercise dictionary vocabulary displayBridi)
        , (15, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions")
        , (60, translationExercises1to5_simplified)
        , (12, questionExercises3_simplified)
        , (12, abstractionExercises4_simplified)
        ]
    where
        vocabulary = vocabularyGenerator5 dictionary
        displayBridi = simplifyTerminatorsInBridiDisplayer $ (combineFunctions [(7, displayStandardSimpleBridi), (2, displayVariantSimpleBridi), (1, displayReorderedStandardSimpleBridi)])

exercises7 :: Dictionary -> ExerciseGenerator
exercises7 dictionary =
    combineFunctions
        [ (20, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions")
        , (70, translationExercises7)
        , (15, fillingBlanksExercises7)
        ]
    where
        vocabulary = vocabularyGenerator7 dictionary

exercises8 :: Dictionary -> ExerciseGenerator
exercises8 dictionary =
    combineFunctions
        [ (20, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions" ++ getVocabularySelbri vocabulary "relations")
        , (70, translationExercises8)
        ]
    where
        vocabulary = vocabularyGenerator8 dictionary

exercises9 :: Dictionary -> ExerciseGenerator
exercises9 dictionary =
    combineFunctions
        [ (20, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions" ++ getVocabularySelbri vocabulary "relations")
        , (80, translationExercises9)
        ]
    where
        vocabulary = vocabularyGenerator9 dictionary

exercises10 :: Dictionary -> ExerciseGenerator
exercises10 dictionary =
    combineFunctions
        [ (10, generateIsolatedBrivlaPlacesExercise dictionary $ generatorFromWeightedList $ getVocabularySelbri vocabulary "actions" ++ getVocabularySelbri vocabulary "relations")
        , (70, translationExercises10_restricted)
        , (15, translationExercises10_unrestricted)
        , (20, fillingBlanksExercises10)
        ]
    where
        vocabulary = vocabularyGenerator10 dictionary