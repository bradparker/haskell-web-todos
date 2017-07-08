module Main where

import Api

main :: IO ()
main = do
  env <- createEnv
  run env
