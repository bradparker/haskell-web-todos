{-# LANGUAGE OverloadedStrings #-}

module Api.Todo.Routes (routes) where

import Api.Todo.Database (echo)
import Api.Todo.Model (Todo(..))
import Api.Types (Api, Action, Env(..))
import Data.Text.Lazy (pack)
import Web.Scotty.Trans (text, get)
import Api.Database (withConnection)

todo = Todo
  { _id = "abc-132"
  , description = "A thing, woot"
  , state = 1
  , created_at = "2017-01-01"
  , updated_at = "2017-01-01"
  }

listTodos :: Action ()
listTodos = do
  todos <- withConnection (echo todo)
  text (pack (show todos))

routes :: Api ()
routes = do
  get "/todos" listTodos
