{-# LANGUAGE NamedFieldPuns #-}

module Database
  ( databaseConnectionPool
  , databaseConnectionPoolFromEnv
  , connectionConfigFromEnv
  , ConnectionConfig(..)
  ) where

import Data.Pool (Pool, createPool)
import Database.HDBC (disconnect)
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL)
import System.Environment (lookupEnv)

import Database.URL
import Database.Configuration.Connection

databaseConnectionPool
  connectionConfig
  subPools
  reapTime
  maxConnections =
    createPool
      (connectPostgreSQL (asConnectionString connectionConfig))
      disconnect
      subPools
      reapTime
      maxConnections

databaseConnectionPoolFromEnv
  subPools
  reapTime
  maxConnections = do
    connectionConfig <- connectionConfigFromEnv
    databaseConnectionPool
      connectionConfig
      subPools
      reapTime
      maxConnections

emptyConnectionConfig = ConnectionConfig
  { host = ""
  , port = ""
  , user = ""
  , password = ""
  , dbname = ""
  }

connectionConfigFromEnv :: IO (ConnectionConfig)
connectionConfigFromEnv = do
  url <- lookupEnv "DATABASE_URL"
  let config = url >>= parseDatabaseURL
  return (maybe emptyConnectionConfig id config)
