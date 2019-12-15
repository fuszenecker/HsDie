module Main (main, isPrimeTest, permutationsTest) where

import Lib
import MyMonad
import Control.Parallel
import Control.Parallel.Strategies

import Test.Hspec
--import Test.QuickCheck
import Control.Exception (evaluate)

main :: IO ()
main = hspec $ do
    describe "My Test souite" $ do
        it "... runs prime test." $ do
            isPrimeTest `shouldBe` True

        it "... runs monad tests." $ do
            myMonadTest

        describe "My Test souite" $ do
            it "... runs permutation tests." $ do
                permutationsTest

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

permutationsTest =
    (length . permutations2) [1,2,3,4,5,6,7] == 5040

-- >>> permutationsTest
