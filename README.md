# Repositorium ad Haskellem demonstrandum.

Repositorium quo fontes in Haskelle scripti collecti sunt.

[![Build Status](https://travis-ci.org/fuszenecker/HaskellDemo.svg?branch=master)](https://travis-ci.org/fuszenecker/HaskellDemo)

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

Exempli gratia:

```
GHCi> Any True <> Any True <> Any False
Any {getAny = True}
GHCi> All True <> All True <> All False
All {getAll = False}
```

