{-# LANGUAGE NamedFieldPuns #-}

module Database
  ( databaseConnectionPool
  , databaseConnectionPoolFromEnv
  ) where

import Data.Pool (Pool, createPool)
import Database.HDBC (disconnect)
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL)
import System.Environment (lookupEnv)

databaseConnectionPool
  connectionUrl
  subPools
  reapTime
  maxConnections =
    createPool
      (connectPostgreSQL connectionUrl)
      disconnect
      subPools
      reapTime
      maxConnections

databaseConnectionPoolFromEnv
  subPools
  reapTime
  maxConnections = do
    connectionUrl <- connectionConfigUrlFromEnv
    databaseConnectionPool
      connectionUrl
      subPools
      reapTime
      maxConnections

connectionConfigUrlFromEnv :: IO String
connectionConfigUrlFromEnv = do
  url <- lookupEnv "DATABASE_URL"
  return (maybe "" id url)
