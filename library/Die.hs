module Die
    (
        -- Types:
        Date (..),

        -- Functions:
        dateToString,
        stringToDate
    ) where

import Data.Char

-- | Type to store date.
data Date = Date {
    year :: Int,
    month :: Int,
    day :: Int
} deriving (Eq)

instance Show Date where
    show x = show (year x) ++ ". " ++ show (month x) ++ ". " ++ show (day x) ++ "."

-- | Converts a date to a string. If any of the year/month/day is non-positive, the result will be an error.
-- >>> dateToString $ Date 1978 10 27
-- Right "BPWKB"
--
-- >>> dateToString $ Date (-1978) 10 27
-- Left "Numerus non est maior quam nulla."
--
dateToString :: Date -> Either String String
dateToString (Date y m d) | y > 0 && m > 0 && d > 0 = Right $ intToString (((y - 1) * 12 + m - 1) * 31 + d - 1)
    where
        intToString 0 = "A"
        intToString j | j > 0 = intToStringV [] j
        intToString _ = ""

        intToStringV v i | i > 0 = intToStringV ([chr $ 65 + i `rem` 26] ++ v) (i `div` 26)
        intToStringV v _ = v

dateToString _ = Left "Numerus non est maior quam nulla."

-- | Converts any string to a date. Non-apha characters are ignored.
-- >>> stringToDate "BPWKB"
-- @
-- 1978. 10. 27.
-- @
--
-- >>> stringToDate "A"
-- @
-- 1. 1. 1.
-- @
--
-- >>> stringToDate "_AliQuid"
-- @
-- 361952. 4. 27.
-- @
--
stringToDate :: String -> Date
stringToDate s = Date
        (index `div` (12 * 31) + 1)
        ((index `div` 31) `mod` 12 + 1)
        (index `mod` 31 + 1)
    where
        cleanString = filter isAlpha . map toUpper
        index = foldl (\a x -> a * 26 + ord x - 65) 0 $ cleanString s
