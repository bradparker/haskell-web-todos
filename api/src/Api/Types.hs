{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Api.Types (Api, Action, Env(..), runEnvT) where

import Web.Scotty.Trans (ScottyT, ActionT)
import Data.Pool (Pool)
import Database.HDBC.PostgreSQL (Connection)
import Control.Applicative (Applicative)
import Control.Monad.IO.Class (MonadIO)
import Data.Text.Lazy (Text)
import Control.Monad.Reader (ReaderT, MonadReader)

data Env = Env { databaseConnectionPool :: Pool Connection }

newtype EnvT a = EnvT
  { runEnvT :: ReaderT Env IO a }
  deriving
    ( Applicative
    , Functor
    , Monad
    , MonadIO
    , MonadReader Env
    )

type Error = Text
type Action = ActionT Error EnvT
type Api = ScottyT Error EnvT

