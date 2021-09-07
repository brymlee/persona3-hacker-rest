module Test.Main (main) where

import Control.Bind (discard)
import Data.Unit (Unit)
import Effect (Effect)
import Main ( isNextCharacter
            , isFirstCharacterCurlyBracket
            , isFirstCharacterSquareBracket)
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
  assert $ isFirstCharacterCurlyBracket [" ", " ", "{"]
  assert $ isFirstCharacterCurlyBracket [" ", " ", "["] == false
  assert $ isFirstCharacterSquareBracket [" ", " ", "["]
  assert $ isFirstCharacterSquareBracket [" ", " ", "{"] == false
