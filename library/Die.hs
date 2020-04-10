-- | An example module.
module Die where

import System.Environment (getArgs)
import Main.Utf8 (withUtf8)
import Text.Read (readMaybe)

import Data.Time.Clock
import Data.Time.Calendar
import Data.Char

today :: IO (Integer, Int, Int) -- :: (year, month, day)
today = getCurrentTime >>= return . toGregorian . utctDay

data Date = Date {
    year :: Int,
    month :: Int,
    day :: Int
} deriving (Eq)

instance Show Date where
    show x = show (year x) ++ ". " ++ show (month x) ++ ". " ++ show (day x) ++ "."

main :: IO ()
main = withUtf8 utf8Main

dateToString :: Date -> String
dateToString (Date y m d) = intToString (((y - 1) * 12 + m - 1) * 31 + d - 1)

stringToDate :: String -> Date
stringToDate s = Date
        (index `div` (12 * 31) + 1)
        ((index `div` 31) `mod` 12 + 1)
        (index `mod` 31 + 1)
    where
        index = foldl (\a x -> a * 26 + ord x - 65) 0 s

intToString :: Int -> String
intToString 0 = "A"
intToString j = intToStringV [] j
    where
        intToStringV v i =
            if i > 0 then
                intToStringV ([(chr $ 65 + i `rem` 26)] ++ v) (i `div` 26)
            else
                v

printUsage :: IO ()
printUsage = putStrLn "die <annus> <mensis> <dies> || die <codicellus> || die"

parseArgs :: [String] -> IO ()
parseArgs [] = do
    (y, m, d) <- today
    let date = Date (fromIntegral y) m d
    putStrLn $ "Hodie est: " ++ show date
    parseArgs [show y, show m, show d]

parseArgs [x] = putStrLn $ "Datum: " ++ show (stringToDate x)

parseArgs [_, _] = printUsage

parseArgs [y, m, d] = do
    let date = Date <$> readMaybe y <*> readMaybe m <*> readMaybe d
    let code = dateToString <$> date

    case code of
        Nothing -> putStrLn $ "Convertare datum [" ++ y ++ ", " ++ m ++ ", " ++ d ++ "] non possim."
        Just c -> putStrLn $ "Codicellum: " ++ c

parseArgs _ = printUsage

utf8Main :: IO ()
utf8Main = getArgs >>= parseArgs
