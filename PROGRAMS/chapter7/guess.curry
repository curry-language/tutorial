------------------------------------------------------------------------------
-- Example for CGI programming in Curry:
-- a recursive form for a number guessing game
-- which also counts the number of guesses
------------------------------------------------------------------------------

import HTML.Base

guessForm :: IO HtmlForm
guessForm = return $ form "Number Guessing" (guessInput 1)

guessInput :: Int -> [HtmlExp]
guessInput n =
  [htxt "Guess a natural number: ", textfield nref "",
   button "Check" (guessHandler n nref)]   where nref free

guessHandler :: Int -> CgiRef -> (CgiRef -> String) -> IO HtmlForm
guessHandler n nref env =
  return $ form "Answer" $
    case reads (env nref) of
      [(nr,"")] ->
         if nr==42
           then [h1 [htxt $ "Right! You needed "++show n++" guesses!"]]
           else [h1 [htxt $ if nr<42 then "Too small!"
                                     else "Too large!"],
                 hrule] ++ guessInput (n+1)
      _ -> [h1 [htxt "Illegal input, try again!"]] ++ guessInput n

-- Install the CGI program by:
-- curry-makecgi -o guess.cgi -m guessForm guess
