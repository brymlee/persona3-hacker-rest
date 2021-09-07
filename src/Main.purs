module Main ( main
            , isNextCharacter 
            , isFirstCharacterCurlyBracket
            , isFirstCharacterSquareBracket) where 
import Query (query, tail)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Response (send)
import Node.HTTP (Server)
import Data.Functor (map)
import Data.String (joinWith)
import Data.Show (show)
import Node.HTTP (Server)
import Data.Array (concat, head, length)
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

isFirstCharacterCurlyBracket :: Array String -> Boolean
isFirstCharacterCurlyBracket xs = isNextCharacter $ concat [["{"], xs]

isFirstCharacterSquareBracket :: Array String -> Boolean
isFirstCharacterSquareBracket xs = isNextCharacter $ concat [["["], xs]
