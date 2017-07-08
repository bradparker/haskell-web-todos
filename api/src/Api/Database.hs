module Api.Database (withConnection) where

import Api.Types (Action, Env(..))
import Data.Pool (withResource)
import Control.Monad.Reader (asks, liftIO, lift)
import Database.HDBC.PostgreSQL (Connection)

withConnection :: (Connection -> IO b) -> Action b
withConnection action = do
  pool <- lift (asks databaseConnectionPool)
  liftIO (withResource pool action)
