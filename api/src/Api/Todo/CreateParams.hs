{-# LANGUAGE DeriveGeneric #-}

module Api.Todo.CreateParams
  ( CreateParams(..)
  ) where

import GHC.Generics
import Data.Aeson

data CreateParams = CreateParams
  { description :: String
  } deriving (Show, Generic)

instance ToJSON CreateParams
instance FromJSON CreateParams
