module Api.Todo.Database (
  echo
) where

import Database.HDBC (fromSql, toSql, SqlValue)
import Database.HDBC.PostgreSQL (Connection)
import Database.Query (Query(..), execute)
import Api.Todo.Model (Todo(..))

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

echoSql :: String
echoSql =
  "select \
  \?::text as _id, \
  \?::text as description, \
  \?::int as state, \
  \?::text as created_at, \
  \?::text as updated_at"

echoQuery :: TodoQuery
echoQuery = baseQuery echoSql

echo :: Todo -> Connection -> IO [Todo]
echo = execute echoQuery
