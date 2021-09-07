module Test.Main (main) where

import Control.Bind (discard)
import Data.Unit (Unit)
import Effect (Effect)
import Main ( isNextCharacter
            , isFirstCharacterOpenCurlyBracket
            , isFirstCharacterOpenSquareBracket
            , isLastCharacterClosedCurlyBracket
            , isStartingCurlyBrackets
            ) 
import Test.Assert (assert)
import Data.Function (($))
import Prim (Boolean(..))
import Data.Eq ((==))

main :: Effect Unit
main = do
  assert $ isNextCharacter ["{", "{"] 
  assert $ isNextCharacter ["{", "["] == false
  assert $ isNextCharacter ["{", " ", "{"]
  assert $ isNextCharacter ["a", " ", " ", "b"] == false
  assert $ isFirstCharacterOpenCurlyBracket [" ", " ", "{"]
  assert $ isFirstCharacterOpenCurlyBracket [" ", " ", "["] == false
  assert $ isFirstCharacterOpenSquareBracket [" ", " ", "["]
  assert $ isFirstCharacterOpenSquareBracket [" ", " ", "{"] == false
  assert $ isLastCharacterClosedCurlyBracket [" ", "[", "}"]
  assert $ isLastCharacterClosedCurlyBracket [" ", "{", "]"] == false
  assert $ isStartingCurlyBrackets [" ", "{", "a", "}", " "]
  assert $ isStartingCurlyBrackets [" ", "{", "b", "]", " "] == false
