module Lib
    ( someFunc
    , isPrime
    , isPrimes
    ) where

import Control.Parallel
import Control.Parallel.Strategies

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- |Checks is the argument prime
isPrime :: Integer -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime 2 = True
isPrime x = 2 ^ x `mod` x == 2

isPrimesPar :: [Integer] -> [Bool]
isPrimesPar =
  parMap rseq isPrime

-- |Checks is the array elements are prime
isPrimes :: [Integer] -> [Bool]
isPrimes =
  map isPrime

fact :: (Num b, Enum b) => b -> b
fact n = foldr (*) 1 $ (\x -> [1..x]) n

fact' :: Integer -> Integer
fact' = foldr (*) 1 . (\x -> [1..x])
