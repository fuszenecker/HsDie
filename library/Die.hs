-- | An example module.
module Die (main) where

import Main.Utf8 (withUtf8)

-- | An example function.
main :: IO ()
main = withUtf8 utf8Main

utf8Main :: IO ()
utf8Main = return ()