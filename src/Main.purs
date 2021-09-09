module Main ( main
            , isNextCharacter 
            , isFirstCharacterOpenCurlyBracket
            , isFirstCharacterOpenSquareBracket
            , isLastCharacterClosedCurlyBracket
            , isLastCharacterClosedSquareBracket
            , isStartingCurlyBrackets
            , isStartingSquareBrackets
            , isEitherStartingCurlyOrSquareBrackets 
            , isCorrectCharactersAfterComma 
            , isValidJson 
            ) where
import Query (query, tail)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Response (send)
import Node.HTTP (Server)
import Data.Functor (map)
import Data.String (joinWith, split, Pattern(..))
import Data.Show (show)
import Data.Array (concat, head, reverse, all, any, length)
import Prim (String(..), Array(..), Boolean(..))
import Data.Function (($))
import Data.Boolean (otherwise)
import Data.Ord ((<))
import Data.Eq ((==))
import Data.Maybe (Maybe(..))

app :: App
app = get "/" $ send $ joinWith " " $ map (\ it -> show it) $ query ["Characters"]

main :: Effect Server
main = do
  listenHttp app 80 \_ -> 
    log $ joinWith "" $ concat [["Listening on ", show 80]] 

isNextCharacter :: Array String -> Boolean
isNextCharacter xs | length xs < 2 = false
                   | Just " " == head (tail xs) = isNextCharacter' $ head xs
                       where
                         isNextCharacter' :: Maybe String -> Boolean
                         isNextCharacter' Nothing = false
                         isNextCharacter' (Just x) = isNextCharacter $ concat [[x], tail ( tail xs)]
                   | otherwise = head xs == head (tail xs)

isFirstCharacterOpenCurlyBracket :: Array String -> Boolean
isFirstCharacterOpenCurlyBracket xs = isNextCharacter $ concat [["{"], xs]

isFirstCharacterOpenSquareBracket :: Array String -> Boolean
isFirstCharacterOpenSquareBracket xs = isNextCharacter $ concat [["["], xs]

isLastCharacterClosedCurlyBracket :: Array String -> Boolean
isLastCharacterClosedCurlyBracket xs = isNextCharacter $ concat [["}"], reverse xs]

isLastCharacterClosedSquareBracket :: Array String -> Boolean
isLastCharacterClosedSquareBracket xs = isNextCharacter $ concat [["]"], reverse xs]

isStartingCurlyBrackets :: Array String -> Boolean
isStartingCurlyBrackets xs = all (\ it -> it) [ isFirstCharacterOpenCurlyBracket xs
                                              , isLastCharacterClosedCurlyBracket xs]

isStartingSquareBrackets :: Array String -> Boolean
isStartingSquareBrackets xs = all (\ it -> it) [ isFirstCharacterOpenSquareBracket xs
                                               , isLastCharacterClosedSquareBracket xs]

isEitherStartingCurlyOrSquareBrackets :: Array String -> Boolean
isEitherStartingCurlyOrSquareBrackets xs = any (\ it -> it) [ isStartingCurlyBrackets xs
                                                            , isStartingSquareBrackets xs]

isCorrectCharactersAfterComma :: Array String -> Boolean
isCorrectCharactersAfterComma xs' = f (head xs') (tail xs') false
  where
    f' :: Array String -> Boolean
    f' xs = f (head xs) (tail xs) false
    f :: Maybe String -> Array String -> Boolean -> Boolean
    f Nothing _ _ = true
    f (Just " ") xs b = f (head xs) (tail xs) b 
    f (Just ",") _ true = false
    f (Just ",") xs false | length xs == 0 = false
                          | otherwise = f (head xs) (tail xs) true 
    f (Just "{") xs _ = f' xs
    f (Just "[") xs _ = f' xs 
    f (Just "}") _ true = false
    f (Just "}") xs false = f' xs 
    f (Just "]") _ true = false
    f (Just "]") xs false = f' xs 
    f (Just "\"") xs _ = f' xs 
    f (Just "f") xs _ = f' xs 
    f (Just "a") _ true = false
    f (Just "a") xs false = f' xs 
    f (Just "l") _ true = false
    f (Just "l") xs false = f' xs 
    f (Just "s") _ true = false
    f (Just "s") xs false = f' xs 
    f (Just "e") _ true = false
    f (Just "e") xs false = f' xs 
    f (Just "t") xs _ = f' xs 
    f (Just "r") _ true = false
    f (Just "r") xs false = f' xs
    f (Just "u") _ true = false
    f (Just "u") xs false = f' xs 
    f (Just "0") xs _ = f' xs
    f (Just "1") xs _ = f' xs 
    f (Just "2") xs _ = f' xs
    f (Just "3") xs _ = f' xs 
    f (Just "4") xs _ = f' xs
    f (Just "5") xs _ = f' xs
    f (Just "6") xs _ = f' xs
    f (Just "7") xs _ = f' xs
    f (Just "8") xs _ = f' xs 
    f (Just "9") xs _ = f' xs 
    f (Just "-") xs _ = f' xs
    f (Just _) _ true = false 
    f (Just _) xs false = f' xs

isValidJson :: String -> Boolean
isValidJson s = all (\ it -> it) [ isEitherStartingCurlyOrSquareBrackets xs
                                 , isCorrectCharactersAfterComma xs]
  where
    xs = split (Pattern "") s
