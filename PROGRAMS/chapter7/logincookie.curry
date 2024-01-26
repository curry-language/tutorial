------------------------------------------------------------------------------
-- Example for CGI programming with cookies in Curry:
-- a login page setting a cookie and another page using this cookie
--
-- Michael Hanus
------------------------------------------------------------------------------

import HTML.Base

loginForm :: HtmlFormDef ()
loginForm = simpleFormDef
  [htxt "Enter your name: ", textField tref "",
   hrule,
   button "Login" handler
  ]
 where
   tref free

   handler env = return $
     addCookies [("LOGINNAME", env tref)] $
       page "Logged In"
            [h2 [htxt $ env tref ++ ": thank you for visiting us"]]

loginPage :: IO HtmlPage
loginPage = return $ page "Login" [formElem loginForm]


-- Page to read the cookie:
getNamePage :: IO HtmlPage
getNamePage = do
  cookies <- getCookies
  return $ page "Hello" $
    maybe [h1 [htxt "Not yet logged in"]]
          (\n -> [h1 [htxt $ "Hello, " ++ n]])
          (lookup "LOGINNAME" cookies)

-- Install the scripts by:
-- curry2cgi -o login.cgi   -m loginPage   logincookie
-- curry2cgi -o getname.cgi -m getNamePage logincookie
