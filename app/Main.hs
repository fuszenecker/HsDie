module Main where

import Lib
import MyMonadMod

main :: IO ()
main =
  putStrLn $ "X: " ++ show (isPrimes [100000000..100000030])
