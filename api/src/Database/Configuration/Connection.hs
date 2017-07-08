module Database.Configuration.Connection (ConnectionConfig(..)) where

data ConnectionConfig = ConnectionConfig
  { host :: String
  , port :: String
  , user :: String
  , password :: String
  , dbname :: String
  } deriving Show
