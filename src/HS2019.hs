module HS2019 (
    main
) where

import Data.List (sort, nub, unfoldr)

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

euler32 :: () -> String
euler32 () =
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

euler33 :: () -> String
euler33 () =
    show $
    take 1 $ 
    filter fst $
    unfoldr
        (\i -> Just(
            (length(dedupFactorize $ i) == 4 &&
            length(dedupFactorize $ i + 1) == 4 &&
            length(dedupFactorize $ i + 2) == 4 &&
            length(dedupFactorize $ i + 3) == 4, i
            )
            , i + 1)
        )
        1

main () =
    -- euler32 ()
    euler33()
