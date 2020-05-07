module Die
    (
        Date (..),

        main,
        dateToString,
        stringToDate
    ) where

import System.Environment (getArgs)
import Main.Utf8 (withUtf8)
import Text.Read (readMaybe)

import Data.Time.Clock
import Data.Time.Calendar
import Data.Char

data Date = Date {
    year :: Int,
    month :: Int,
    day :: Int
} deriving (Eq)

instance Show Date where
    show x = show (year x) ++ ". " ++ show (month x) ++ ". " ++ show (day x) ++ "."

-- | Main method.
main :: IO ()
main = withUtf8 utf8Main

-- | Converts a date to a string. If any of the year/month/day is non-positive, the result will be an error.
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
stringToDate :: String -> Date
stringToDate s = Date
        (index `div` (12 * 31) + 1)
        ((index `div` 31) `mod` 12 + 1)
        (index `mod` 31 + 1)
    where
        cleanString = (filter isAlpha) . (map toUpper)
        index = foldl (\a x -> a * 26 + ord x - 65) 0 $ cleanString s

printUsage :: IO ()
printUsage = putStrLn "die <annus> <mensis> <dies> || die <codicellus> || die"

dateToCode :: Maybe Date -> IO ()
dateToCode date = do
    let code = dateToString <$> date

    case code of
        Nothing -> putStrLn $ "Convertere datum [" ++ show date ++ "] non possum."
        Just c ->
            case c of
                Right cc -> putStrLn $ "Codicellum: " ++ cc
                Left e -> putStrLn e

parseArgs :: [String] -> IO ()
parseArgs [] = do
    date <- today
    putStrLn $ "Hodie est: " ++ show date
    dateToCode $ Just date

    where
        today = do
            (y, m, d) <- toGregorian . utctDay <$> getCurrentTime
            return $ Date (fromIntegral y) m d

parseArgs [x] = putStrLn $ "Datum: " ++ show (stringToDate x)
parseArgs [_, _] = printUsage
parseArgs [y, m, d] = dateToCode $ Date <$> readMaybe y <*> readMaybe m <*> readMaybe d
parseArgs _ = printUsage

utf8Main :: IO ()
utf8Main = getArgs >>= parseArgs
