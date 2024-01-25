-- A few simple examples for I/O programming

import Data.Char


-- An I/O action thats copies the standard input to standard output
-- until the first period character:

echo :: IO ()
echo = getChar >>= \c -> if c=='.' then return () else putChar c >> echo


-- The same I/O action using the "do" notation:

echoDo :: IO ()
echoDo = do c <- getChar
            if c=='.'
              then return ()
              else do putChar c
                      echoDo


-- Copy a file with transforming all lowercase into uppercase letters:
convertFile :: String -> String -> IO ()
convertFile input output = do
  s <- readFile input
  writeFile output (map toUpper s)

-- end of I/O examples
