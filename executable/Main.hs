module Main where

import Data.Time.Calendar
import Data.Time.Clock

import System.Environment (getArgs)
import Main.Utf8 (withUtf8)
import Text.Read (readMaybe)

import qualified Die

-- | UTF-8-safe main method.
main :: IO ()
main = withUtf8 utf8Main

printUsage :: IO ()
printUsage = putStrLn "die <annus> <mensis> <dies> || die <codicellus> || die"

dateToCode :: Maybe Die.Date -> IO ()
dateToCode date = do
    let code = Die.dateToString <$> date

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
            return $ Die.Date (fromIntegral y) m d

parseArgs [x] = putStrLn $ "Datum: " ++ show (Die.stringToDate x)
parseArgs [_, _] = printUsage
parseArgs [y, m, d] = dateToCode $ Die.Date <$> readMaybe y <*> readMaybe m <*> readMaybe d
parseArgs _ = printUsage

-- | Main method.
utf8Main :: IO ()
utf8Main = getArgs >>= parseArgs
