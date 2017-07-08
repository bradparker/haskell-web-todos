{-# LANGUAGE NamedFieldPuns #-}

module Database.URL (parseDatabaseURL, asConnectionString) where

import Database.Configuration.Connection
import Network.URI

allUntil char = takeWhile (/= char)
allAfter char = tail . (dropWhile (/= char))

parseUserInfo :: [Char] -> [[Char]]
parseUserInfo info =
  [allUntil ':', allAfter ':'] <*> [allUntil '@' info]

config :: URI -> Maybe ConnectionConfig
config (URI
  { uriAuthority = Nothing
  }) = Nothing

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
      [uriUser, uriPassword] = parseUserInfo uriUserInfo

parseDatabaseURL :: String -> Maybe ConnectionConfig
parseDatabaseURL str = parseURI str >>= config

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
