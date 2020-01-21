# Repositorium ad Haskellem demonstrandum.

Repositorium quo fontes in Haskelle scripti collecti sunt.

[![Build Status](https://travis-ci.org/fuszenecker/HaskellDemo.svg?branch=master)](https://travis-ci.org/fuszenecker/HaskellDemo)

## Generalia

```
GHCi> :set -XTypeApplications
GHCi> :type fmap @Maybe
fmap @Maybe :: (a -> b) -> Maybe a -> Maybe b
```

## Semigroup atque Monoid

```
class Semigroup a where
  (<>) :: a -> a -> a

class Semigroup a => Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mconcat :: [a] -> a
```

### All et Any

```
newtype All = All {getAll :: Bool}
instance Monoid All

newtype Any = Any {getAny :: Bool}
instance Monoid Any
```

Exampli gratia:

```
GHCi> Any True <> Any True <> Any False
Any {getAny = True}
GHCi> All True <> All True <> All False
All {getAll = False}
GHCi> Sum 10 <> Sum 20 <> Sum 30
Sum {getSum = 60}
GHCi> Product 10 <> Product 20 <> Product 30
Product {getProduct = 6000}

GHCi> mconcat [All True, All True, All False]
All {getAll = False}
GHCi> mconcat [Any True, Any True, Any False]
Any {getAny = True}
```

Monoides monoidum:

```
GHCi> mconcat [Just $ Sum 10, Just $ Sum 20, Just $ Sum 30]
Just (Sum {getSum = 60})
GHCi> mconcat [Just $ Sum 10, Nothing, Just $ Sum 30]
Just (Sum {getSum = 40})
GHCi> mconcat [Just $ Sum 10, mempty, Just $ Sum 30]
Just (Sum {getSum = 40})
```

## Functor

```
class Functor (f :: * -> *) where
  fmap :: (a -> b) -> f a -> f b
  (<$) :: a -> f b -> f a
```

Exampli gratia:

```
GHCi> fmap (*10) [1, 2, 3, 4, 5]
[10,20,30,40,50]
GHCi> 10 <$ [1, 2, 3, 4, 5]
[10,10,10,10,10]

GHCi> fmap (*10) $ Just 20
Just 200
GHCi> 10 <$ Just 0
Just 10
```

Etiam functiones sunt functores:

```
GHCi> functionFunctor = fmap (+1) negate
GHCi> :t functionFunctor
functionFunctor :: Num b => b -> b
GHCi> functionFunctor 10
-9
```
