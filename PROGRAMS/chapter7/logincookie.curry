------------------------------------------------------------------------------
-- Example for CGI programming with cookies in Curry:
-- a login form setting a cookie and another form using this cookie
--
-- Michael Hanus
------------------------------------------------------------------------------

import HTML.Base

loginForm :: IO HtmlForm
loginForm = return $ form "Login"
  [htxt "Enter your name: ", textfield tref "",
   hrule,
   button "Login" handler
  ]
 where
   tref free

   handler env = return $
     cookieForm "Logged In"
                [("LOGINNAME", env tref)]
                [h2 [htxt $ env tref ++ ": thank you for visiting us"]]

getNameForm :: IO HtmlForm
getNameForm = do
  cookies <- getCookies
  return $ form "Hello" $
   maybe [h1 [htxt "Not yet logged in"]]
         (\n -> [h1 [htxt $ "Hello, " ++ n]])
         (lookup "LOGINNAME" cookies)

-- Install the scripts by:
-- curry-makecgi -o login.cgi   -m loginForm   logincookie
-- curry-makecgi -o getname.cgi -m getNameForm logincookie
