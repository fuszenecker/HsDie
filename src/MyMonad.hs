module MyMonad
    ( MyMonadType
    , liftMyMonad
    , v1
    , sv2
    , sv3
    ) where

import Control.Applicative

data MyMonadType x = MyMonad x
                   | Error String

instance Monad MyMonadType where
  -- return :: a -> MyMonadType a
  return = MyMonad
  -- (>>=) :: MyMonadType a -> (a -> MyMonadType b) -> MyMonadType b
  (MyMonad x) >>= f = f x
  Error s >>= f = Error s
  -- fail :: String -> MyMonadType a
  --fail = Error

liftMyMonad :: MyMonadType a -> Maybe a
liftMyMonad (MyMonad x) = Just x
liftMyMonad (Error _) = Nothing

instance Functor MyMonadType where
  -- fmap :: (a -> b) -> MyMonadType a -> MyMonadType b
  fmap f (MyMonad x) = MyMonad (f x)

instance Applicative MyMonadType where
  -- pure :: a -> MyMonadType a
  pure = MyMonad
  -- (<*>) :: MyMonadType (a -> b) -> MyMonadType a -> MyMonadType b
  (MyMonad x) <*> g = fmap x g

operation1 :: MyMonadType Integer
operation1 = return 100
operation2 :: MyMonadType Integer
operation2 = operation1 >>= (\x -> if x == 100 then MyMonad 101 else Error "Not hundred")

-- operation3 :: MyMonadType Integer
-- operation3 = do
--   o1 <- return 100
--   if o1 == 100 then return 101 else fail "MyError"

v1 :: Maybe Integer
v1 = Just 300

sv2 :: Maybe (Integer -> Integer)
sv2 = (+) <$> v1

sv3 :: Maybe Integer
sv3 = sv2 <*> Just 1
