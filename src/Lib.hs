module Lib
    ( someFunc
    , isPrime
    , isPrimes
    ) where

import Control.Parallel
import Control.Parallel.Strategies

someFunc :: IO ()
someFunc = putStrLn "someFunc"

isPrime :: Integer -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime 2 = True
isPrime x = 2 ^ x `mod` x == 2

isPrimes =
  parMap rseq isPrime
  --map isPrime
