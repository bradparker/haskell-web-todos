module Api.Todo.Database
  ( insert
  , findAll
  ) where

import Database.HDBC (fromSql, toSql, SqlValue)
import Database.HDBC.PostgreSQL (Connection)
import Database.Query (Query(..), execute)
import Api.Todo.Todo (Todo(..))

type TodoQuery = Query Todo Todo

encode :: Todo -> [SqlValue]
encode todo =
  map ($ todo)
    [ toSql . _id
    , toSql . description
    , toSql . state
    , toSql . created_at
    , toSql . updated_at
    ]

decode :: [SqlValue] -> Todo
decode [_i, d, s, c_at, u_at] =
  Todo
    { _id = fromSql _i
    , description = fromSql d
    , state = fromSql s
    , created_at = fromSql c_at
    , updated_at = fromSql u_at
    }

baseQuery :: String -> TodoQuery
baseQuery = Query encode decode

findAllSql :: String
findAllSql =
  "select \
  \_id, \
  \description, \
  \state, \
  \created_at, \
  \updated_at \
  \from todos"

findAllQuery = Query id decode findAllSql
findAll = execute findAllQuery

insertSql :: String
insertSql =
  "insert into todos \
  \(_id, description, state, created_at, updated_at) \
  \values \
  \(?, ?, ?, ?, ?) \
  \returning _id, description, state, created_at, updated_at"

insertQuery :: TodoQuery
insertQuery = baseQuery insertSql

insert :: Todo -> Connection -> IO [Todo]
insert = execute insertQuery
