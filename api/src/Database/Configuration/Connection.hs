module Database.Configuration.Connection
  ( ConnectionConfig(..)
  , emptyConnectionConfig
  ) where

data ConnectionConfig = ConnectionConfig
  { host :: String
  , port :: String
  , user :: String
  , password :: String
  , dbname :: String
  } deriving Show

emptyConnectionConfig = ConnectionConfig
  { host = ""
  , port = ""
  , user = ""
  , password = ""
  , dbname = ""
  }
