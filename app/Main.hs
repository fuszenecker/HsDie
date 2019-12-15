module Main where

import qualified Lib as L
import qualified MyMonad as M
import qualified HS2019 as H
import qualified Var as V

import Control.Monad
import Control.Monad.Trans.Maybe
import Control.Monad.Writer.Lazy
import Control.Monad.Writer
import Control.Monad.Reader
import Control.Monad.Except
import Control.Concurrent.MVar
import Control.Concurrent (forkIO, threadDelay)

--import Control.Monad.Trans.Writer.Strict


i :: M.MyMonadType Integer
i =
    return 200

type FF = MaybeT IO

curre :: MaybeT IO String
curre = MaybeT $ do
    pure $ Just "YYY"
    return $ Just "XXX"

logger :: WriterT String (MaybeT IO) ()
logger = do
    liftIO $ putStrLn "CCC"
    l <- liftIO $ runMaybeT curre
    --let z <- runMaybeT curre
    tell $ "XXX" ++ show l

g :: WriterT String IO Integer
g = do
    tell "fff"
    tell "xxx"
    liftIO $ print "Hello from writer"
    return 100

g2 :: Writer String Integer
g2 = do
    tell "Hello"
    tell    "\n"
    tell "Hello, again."
    return 200

g3 :: Maybe String
g3 = do
    x <- Just "200"
    y <- Nothing
    return $ x ++ y

g4 :: Reader String Int
g4 = do
    x <- ask
    --let z = print "Hello to IO"
    return $ length x

g5 :: ExceptT String IO ()
g5 = do
        lift $ putStrLn "Hello from ExceptT"
        -- throwError "eee"
        return ()


main :: IO ()
main = do
    syncSqlite <- newEmptyMVar

    forkIO $ do
        putStrLn "Pensum ad SQLite'em demonstrandum currens."
        V.sqliteDemo
        putStrLn "Factum est pensum ad SQLite'em demonstrandum."
        putMVar syncSqlite True


    -- putStrLn $ "MyMonad result: " ++ show (M.liftMyMonad i)
    -- putStrLn $ "X: " ++ show (L.isPrimes [1020..1030])
    -- putStrLn $ "HS 2019 monstrat: " ++ show (H.main ())
    -- putStrLn $ "HS 2019 parallel tests: " ++ show (H.parallelTests ())

    -- putStrLn "This is the Haskell code. Type 'EXIRE VOLO' to exit."

    -- s <- getLine

    -- let u = curre

    -- unless (s == "EXIRE VOLO") $ main
    ll <- (runMaybeT (runWriterT logger))
    putStrLn $ "LL: " ++ show ll

    l <- (runWriterT g)
    print $ l

    -- putStrLn "őőőááúúúűűű"

    V.luaDemo
    V.mvarDemo

    takeMVar syncSqlite

    return ()
