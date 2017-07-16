{-# LANGUAGE OverloadedStrings #-}

module Api.Todo.Routes (routes) where

import Api.Todo.Database (findAll, insert)
import Api.Todo.Todo (Todo(..))
import qualified Api.Todo.CreateParams as CP
import Api.Types (Api, Action, Env(..))
import Web.Scotty.Trans (json, jsonData, get, post, status)
import Api.Database (withConnection)
import Control.Monad.Reader (liftIO)
import Data.UUID.V4 (nextRandom)
import Data.Time.Clock (getCurrentTime)
import Data.Time.ISO8601 (formatISO8601)
import Network.HTTP.Types (created201)

createTodo :: Action ()
createTodo = do
  params <- jsonData :: Action CP.CreateParams
  uuid <- liftIO (show <$> nextRandom)
  time <- liftIO (formatISO8601 <$> getCurrentTime)
  let todo = Todo
        { _id = uuid
        , description = CP.description params
        , state = 1
        , created_at = time
        , updated_at = time
        }
  [saved] <- withConnection (insert todo)
  status created201
  json saved

listTodos :: Action ()
listTodos = do
  todos <- withConnection (findAll [])
  json todos

routes :: Api ()
routes = do
  post "/todos" createTodo
  get "/todos" listTodos
