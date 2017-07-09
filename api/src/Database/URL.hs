{-# LANGUAGE NamedFieldPuns #-}

module Database.URL (parseDatabaseURL, asConnectionString) where

import Database.Configuration.Connection
import Network.URI

splitOn :: Char -> String -> (String, String)
splitOn char = fmap tail . break (== char)

parseUserInfo :: String -> (String, String)
parseUserInfo = splitOn ':' . takeWhile (/= '@')

config :: URI -> Maybe ConnectionConfig
config (URI { uriAuthority = Nothing }) = Nothing
config (URI
  { uriAuthority = (Just (URIAuth
    { uriRegName
    , uriPort
    , uriUserInfo
    }))
  , uriPath
  }) = Just (ConnectionConfig
    { host = uriRegName
    , port = tail uriPort
    , user = uriUser
    , password = uriPassword
    , dbname = tail uriPath
    })
    where
      (uriUser, uriPassword) = parseUserInfo uriUserInfo

parseDatabaseURL :: String -> Maybe ConnectionConfig
parseDatabaseURL = (config =<<) . parseURI

asConnectionString (ConnectionConfig
  { host
  , port
  , user
  , password
  , dbname }) =
    unwords
      [ "host=" ++ host
      , "port=" ++ port
      , "user=" ++ user
      , "password=" ++ password
      , "dbname=" ++ dbname
      ]
