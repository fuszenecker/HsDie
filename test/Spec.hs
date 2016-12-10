import Lib
import MyMonad
import Control.Parallel
import Control.Parallel.Strategies

main :: IO Integer
main = do
  putStrLn "Test suite *****"
  putStrLn $ "IsPrime: " ++ show isPrimeTest
  putStrLn $ "MyMonad result: " ++ show myMonadTest

  if isPrimeTest && myMonadTest
    then return 0
    else return 1

isPrimeTestNumbers = [
    (0, False),
    (1, False),
    (2, True),
    (3, True),
    (4, False),
    (5, True),
    (6, False),
    (7, True),
    (8, False),
    (9, False),
    (10, False),
    (11, True),
    (12, False),
    (13, True)
  ]

isPrimeTest :: Bool
isPrimeTest = all (\(x, b) -> isPrime x == b) isPrimeTestNumbers

i :: MyMonadType Integer
i =
  return 200

myMonadTest =
  liftMyMonad i == Just 200