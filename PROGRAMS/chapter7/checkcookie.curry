------------------------------------------------------------------------------
-- Example for CGI programming with cookies in Curry:
-- a login form that checks whether cookies are enabled and that
-- sets a cookie
--
-- Michael Hanus
------------------------------------------------------------------------------

import HTML.Base

loginPage :: IO HtmlPage
loginPage = return $
  addCookies [("SETCOOKIE","")] $ page "Login" [formElem loginForm]

loginForm :: HtmlFormDef ()
loginForm = simpleFormDef
  [htxt "Enter your name: ", textField tref "",
   hrule,
   button "Login" handler
  ]
 where
   tref free

   handler env = do
     cookies <- getCookies
     return $
       maybe (page "No cookies" [h2 [htxt "Sorry, can't set cookies."]])
             (\_ -> addCookies [("LOGINNAME",env tref)] $
                      page "Logged In"
                        [h2 [htxt $ env tref ++ ": thank you for visiting us"]])
             (lookup "SETCOOKIE" cookies)

-- Install the script by:
-- curry2cgi -o login.cgi -m loginPage checkcookie
