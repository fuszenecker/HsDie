module Main where

import Lib
import MyMonadMod

i :: MyMonadType Integer
i =
  return 200

main :: IO ()
main = do
  putStrLn $ "MyMonad result: " ++ show (liftMyMonad i)
  putStrLn $ "X: " ++ show (isPrimes [100000000..100000030])
