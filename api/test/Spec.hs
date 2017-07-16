{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON
import Network.Wai (Application)

import Api (app, createEnv)

main :: IO ()
main = hspec spec

api :: IO Application
api = do
  env <- createEnv
  app env

spec :: Spec
spec = with api $ do
  describe "GET /todos" $ do
    it "responds" $ do
      get "/todos" `shouldRespondWith`
        [json|[]|]
        { matchStatus = 200
        , matchHeaders = ["Content-Type" <:> "application/json; charset=utf-8"]
        }
