module Api.Todo.Model (
  Todo(..)
) where

data Todo = Todo
  { _id :: String
  , description :: String
  , state :: Int
  , created_at :: String
  , updated_at :: String
  } deriving (Show)

