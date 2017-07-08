module Database.Query (Query(..), execute) where

import qualified Database.HDBC as H
import qualified Database.HDBC.PostgreSQL as H
import Control.Monad

data Query a b = Query
  (a -> [H.SqlValue])
  ([H.SqlValue] -> b)
  String

execThenFetch :: H.Statement -> [H.SqlValue] -> IO [[H.SqlValue]]
execThenFetch statement params = do
  H.execute statement params
  H.fetchAllRows' statement

execute :: Query a b -> a -> H.Connection -> IO [b]
execute (Query encode decode sql) params conn = do
  statement <- H.prepare conn sql
  results <- execThenFetch statement (encode params)
  H.commit conn
  return (map decode results)
