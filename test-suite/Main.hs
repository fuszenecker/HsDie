import qualified Die

import qualified Test.Tasty
import Test.Tasty.Hspec

main :: IO ()
main = do
    test <- testSpec "die" spec
    Test.Tasty.defaultMain test

spec :: Spec
spec = parallel $ do
    it "1. 1. 1. is 'A'" $
        Die.dateToString (Die.Date 1 1 1) `shouldBe` Right "A"

    it "1. 1. 2. is 'B'" $
        Die.dateToString (Die.Date 1 1 2) `shouldBe` Right "B"

    it "1. 1. 3. is 'C'" $
        Die.dateToString (Die.Date 1 1 3) `shouldBe` Right "C"

    it "1. 1. 27. is 'BA'" $
        Die.dateToString (Die.Date 1 1 27) `shouldBe` Right "BA"

    it "2020. 4. 10. is 'BQTFE'" $
        Die.dateToString (Die.Date 2020 4 10) `shouldBe` Right "BQTFE"

    it "-2020. 4. 10. is error" $
        Die.dateToString (Die.Date (-2020) 4 10) `shouldBe` Left "Numerus non est maior quam nulla."

    it "2020. -4. 10. is error" $
        Die.dateToString (Die.Date 2020 (-4) 10) `shouldBe` Left "Numerus non est maior quam nulla."

    it "2020. 4. -10. is error" $
        Die.dateToString (Die.Date 2020 4 (-10)) `shouldBe` Left "Numerus non est maior quam nulla."

    it "'A' is 1. 1. 1." $
        Die.stringToDate "A" `shouldBe` Die.Date 1 1 1

    it "'B' is 1. 1. 2." $
        Die.stringToDate "B" `shouldBe` Die.Date 1 1 2

    it "'C' is 1. 1. 3." $
        Die.stringToDate "C" `shouldBe` Die.Date 1 1 3

    it "'BA' is 1. 1. 27." $
        Die.stringToDate "BA" `shouldBe` Die.Date 1 1 27

    it "'BQTFE' is 2020. 4. 10." $
        Die.stringToDate "BQTFE" `shouldBe` Die.Date 2020 4 10

    it "'bqtFE' is 2020. 4. 10." $
        Die.stringToDate "bqtFE" `shouldBe` Die.Date 2020 4 10

    it "'bq-tFE' is 2020. 4. 10." $
        Die.stringToDate "bq-tFE" `shouldBe` Die.Date 2020 4 10
