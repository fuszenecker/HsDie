module Main where

import qualified Lib as L
import qualified MyMonad as M

i :: M.MyMonadType Integer
i =
  return 200

main :: IO ()
main = do
  putStrLn $ "MyMonad result: " ++ show (M.liftMyMonad i)
  putStrLn $ "X: " ++ show (L.isPrimes [100000000..100000030])
