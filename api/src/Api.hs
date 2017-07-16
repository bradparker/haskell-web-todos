{-# LANGUAGE NamedFieldPuns #-}

module Api
  ( run
  , app
  , createEnv
  ) where

import Web.Scotty.Trans (Options(..), scottyOptsT, scottyAppT)
import Control.Monad.Reader (runReaderT)
import Network.Wai.Handler.Warp (defaultSettings)
import Network.Wai (Application)

import Database (databaseConnectionPoolFromEnv)

import qualified Api.Todo as Todo
import Api.Types (Api, Env(..), runEnvT)

subPools = 1
reapTime = 10
maxConnections = 8

createEnv :: IO Env
createEnv = do
  databaseConnectionPool <- databaseConnectionPoolFromEnv subPools reapTime maxConnections
  return Env { databaseConnectionPool }

run :: Env -> IO ()
run env = do
  let envReader m = runReaderT (runEnvT m) env
  let options = Options { verbose = 1, settings = defaultSettings }
  scottyOptsT options envReader api

app :: Env -> IO Application
app env = do
  let envReader m = runReaderT (runEnvT m) env
  scottyAppT envReader api

api :: Api ()
api = do
  Todo.routes

