{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Control.Exception.Base (bracket)
import Control.Monad.Reader (liftIO)
import Data.Aeson (decode, FromJSON)
import Data.Pool (Pool, createPool)
import Database.HDBC (disconnect, runRaw, rollback)
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL')
import Network.HTTP.Types (created201, hContentType)
import Network.Wai (Application)
import Network.Wai.Test (assertStatus, SResponse(..))
import System.Environment (lookupEnv)
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON
import qualified Data.ByteString.Lazy.Internal as B

import Api (app, createEnv)
import Api.Types (Env(..))
import Api.Todo.Todo (Todo(..))

withDatabaseConnection :: ActionWith Connection -> IO ()
withDatabaseConnection action = do
  dbURL <- (maybe "" id) <$> lookupEnv "DATABASE_URL"
  bracket (connectPostgreSQL' dbURL) disconnect action

withRollback :: ActionWith Connection -> IO ()
withRollback action = withDatabaseConnection $ \conn -> do
  runRaw conn "begin;"
  action conn
  runRaw conn "rollback;"

withApi :: ActionWith Application -> IO ()
withApi action = withRollback $ \conn -> do
  pool <- createPool (return conn) disconnect 1 10 1
  api <- app (Env { databaseConnectionPool = pool })
  action api

main :: IO ()
main = hspec spec

jsonContaining :: (Eq a, FromJSON b) => a -> (b -> a) -> B.ByteString -> Bool
jsonContaining expected getter = maybe False ((== expected) . getter) . decode

spec :: Spec
spec =
  describe "Todos API" $ do
    describe "GET /todos" $ do
      around withApi $ do
        it "gets all todos" $ do
          get "/todos" `shouldRespondWith`
            "[]"
            { matchStatus = 200
            , matchHeaders = ["Content-Type" <:> "application/json; charset=utf-8"]
            }

    describe "POST /todos" $ do
      around withApi $ do
        it "creates a todo" $ do
          res <- post "/todos" [json|{description: "Foobar"}|]
          let status = simpleStatus res
              headers = simpleHeaders res
              body = simpleBody res
          liftIO $ do
            status `shouldBe` created201
            headers `shouldSatisfy` elem (hContentType, "application/json; charset=utf-8")
            body `shouldSatisfy` jsonContaining "Foobar" description
            body `shouldSatisfy` jsonContaining 1 state
