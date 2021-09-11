module Main ( main ) where
import Query (query)
import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get)
import Node.Express.Response (send)
import Node.HTTP (Server)
import Data.Functor (map)
import Data.String (joinWith)
import Data.Show (show)
import Data.Array (concat)
import Data.Function (($))

app :: App
app = get "/" $ send $ joinWith " " $ map (\ it -> show it) $ query ["Characters"]

main :: Effect Server
main = do
  listenHttp app 80 \_ -> 
    log $ joinWith "" $ concat [["Listening on ", show 80]] 

