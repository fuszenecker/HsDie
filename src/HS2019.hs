module HS2019 (
    main
) where

import Data.List
import Control.Parallel
import Control.Monad.Par

-- import qualified Prelude
-- import Data.Array.Parallel
-- import Data.Array.Parallel.Prelude
-- import Data.Array.Parallel.Prelude.Double

-- F# operators
(|>) x f = f x

ispandigital :: Integer -> Integer -> Bool
ispandigital x y =
    (sort $ 
        (show x) ++
        (show y) ++
        (show $ x * y)) 
    
    == "123456789"

pandigitalProducts :: () -> [(Integer, Integer, Integer)]
pandigitalProducts () =
    [(i, j, i * j) | 

        -- StackOverflow helped me to reduce the search space
        i <- [1 .. 100], 
        j <- [(if i > 9 then 123 else 1234) .. (if i > 9 then 987 else 9876)],

        ispandigital i j ]

-- | Euler problem 32.
euler32 :: () -> String
euler32 () =
    "Euler 32: " ++

    pandigitalProducts ()
    |> map (\(x, y, p) -> p)    -- get the product only
    |> nub                      -- distinct
    |> sum
    |> show


dedupFactorize :: Integer -> [Integer]
dedupFactorize n = reverse $ nub $ factorize n

factorize :: Integer -> [Integer]
factorize n =
    doFactorize n 2 []

doFactorize :: Integer -> Integer -> [Integer] -> [Integer]
doFactorize 1 _ factors = factors
doFactorize n divisor factors =
    case n `mod` divisor of
        0 -> doFactorize (n `div` divisor) divisor (divisor : factors)
        _ -> doFactorize n (divisor + 1) factors

areSubsequentialFactorized :: Integer -> Bool
areSubsequentialFactorized n =
    p1 `par` p2 `par` p3 `par` p4 `pseq` (p1 && p2 && p3 && p4)
    where
        p1 = length(dedupFactorize $ n) == 4
        p2 = length(dedupFactorize $ n + 1) == 4
        p3 = length(dedupFactorize $ n + 2) == 4
        p4 = length(dedupFactorize $ n + 3) == 4

areSubsequentialFactorized2 :: Integer -> Bool
areSubsequentialFactorized2 n =
    all (== 4) $ runPar $ parMap (\n -> length(dedupFactorize $ n)) [n, n+1, n+2, n+3] 

euler33 :: () -> String
euler33 () =
    show $
    take 1 $ 
    filter fst $
    unfoldr (\i -> Just((areSubsequentialFactorized2 i, i), i + 1)) 1

main () =
    euler32 ()
    -- euler33()
