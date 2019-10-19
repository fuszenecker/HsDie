module HS2019 (
    main
) where

import Data.List (sort, nub)

-- F# operators
(|>) x f = f x
(>>) g f x = f $ g x

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

main () = euler32 ()
