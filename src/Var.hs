{-# LANGUAGE OverloadedStrings #-}

module Var (
    mvarDemo,
    luaDemo,
    sqliteDemo
) where

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar
import Control.Monad.State.Lazy
import Control.Applicative
import qualified Database.SQLite3 as DB
import Data.Text

import Foreign.Lua as Lua

printMessagesFrom :: String -> MVar String -> IO ()
printMessagesFrom name mv = do
        g <- takeMVar mv
        mapM_ (printMessage g) [1..3]

        where
            printMessage g i = do
                sleepMs 100
                putStrLn (name ++ " number " ++ g ++ show i)

            sleepMs n = threadDelay (n * 1000)

mvarDemo :: IO ()
mvarDemo = do
    f <- newMVar $ "Hello"
    g <- newEmptyMVar

    printMessagesFrom "main" f
    putMVar f "Slave 1 -- "
    forkIO (printMessagesFrom "fork 1" f)
    putMVar f "Slave 2 -- "
    forkIO (printMessagesFrom "fork 2" f)
    putMVar f "Slave 3 -- "
    forkIO (printMessagesFrom "fork 3" f)

    sleepMs 2000

    where
        sleepMs n = threadDelay (n * 1000)

luaDemo :: IO Int
luaDemo = do
    retval <- Lua.run prog
    return retval

    where
        prog :: Lua Int
        prog = do
            Lua.openlibs    -- load Lua libraries so we can use 'print'
            Lua.getglobal "print"
            Lua.pushstring "Hello from"
            Lua.getglobal "_VERSION"

            -- Call the stacked function, 2 args, 0 return value
            Lua.call 2 0
            -- Lua.callFunc "print" ("Hello, World!" :: String)

            return 100

sqliteDemo = do
    db <- DB.open "my.db.sqlite3"

    -- DB.exec db "CREATE TABLE A (id INTEGER PRIMARY KEY, name TEXT NOT NULL, value INTEGER)"
    DB.exec db "DELETE FROM a"

    statement <- DB.prepare db "INSERT INTO a (id, name, value) VALUES (?, ?, ?)"

    mapM_ (\n -> do
            DB.bindInt statement (DB.ParamIndex 1) $ n
            DB.bindText statement (DB.ParamIndex 2) $ ("Hello" :: Text)
            DB.bindInt statement (DB.ParamIndex 3) $ n + 1000
            DB.step statement
            DB.reset statement
        ) [1..1000]

    DB.finalize statement
    DB.close db


