module Main where

import qualified Lib as L
import qualified MyMonad as M
import qualified HS2019 as H

i :: M.MyMonadType Integer
i =
  return 200

main :: IO ()
main = do
  putStrLn $ "MyMonad result: " ++ show (M.liftMyMonad i)
  putStrLn $ "X: " ++ show (L.isPrimes [1020..1030])
  putStrLn $ "HS 2019 monstrat: " ++ show (H.main ())
