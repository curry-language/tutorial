------------------------------------------------------------------------------
-- Example for HTML programming in Curry:
--
-- A recursive form for a number guessing game
-- which also counts the number of guesses
------------------------------------------------------------------------------

import HTML.Base
import HTML.Session

--- The data stored in the session is the number of guesses.
trials :: SessionStore Int
trials = sessionStore "trials"

guessForm :: HtmlFormDef Int
guessForm = formDef (getSessionData trials 1) guessFormHtml

guessFormHtml :: Int -> [HtmlExp]
guessFormHtml t =
  [htxt "Guess a number: ", textField nref "",
   button "Check" guessHandler]
 where
  nref free

  guessHandler env =
    case reads (env nref) of
      [(n,"")] -> 
        if n==42
          then do
            removeSessionData trials
            return $ headerPage ("Correct! " ++ show t ++ " guesses!") []
          else do
            putSessionData trials (t+1)
            return $ headerPage ("Too " ++ if n<42 then "small!" else "large!")
               [formElem guessForm ]
      _ -> return $ headerPage "Illegal input, try again!"
             [formElem guessForm]

-- main HTML page containing the form
main :: IO HtmlPage
main = withSessionCookieInfo $
  headerPage "Number Guessing Game" [ formElem guessForm ]

-- Install the CGI script in user homepage by:
-- > curry2cgi -o guess.cgi guess
