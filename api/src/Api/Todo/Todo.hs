{-# LANGUAGE DeriveGeneric #-}

module Api.Todo.Todo
  ( Todo(..)
  ) where

import GHC.Generics
import Data.Aeson

data Todo = Todo
  { _id :: String
  , description :: String
  , state :: Int
  , created_at :: String
  , updated_at :: String
  } deriving (Show, Generic)

instance ToJSON Todo
instance FromJSON Todo
