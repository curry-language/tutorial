------------------------------------------------------------------------------
-- Example for dynamic web programming in Curry:
-- a form with a text input field and two event handlers
------------------------------------------------------------------------------

import HTML.Base

-- The contents of the form.
rdFormContents :: [HtmlExp]
rdFormContents =
  [htxt "Enter a string: ", textField tref "", hrule,
   button "Reverse string"   revhandler,
   button "Duplicate string" duphandler]

 where
  tref free

  revhandler env = return $ page "Answer"
          [h1 [htxt $ "Reversed input: " ++ reverse (env tref)]]

  duphandler env = return $ page "Answer"
          [h1 [htxt $ "Duplicated input: " ++ env tref ++ env tref]]

-- The form definition must be a top-level entity:
rdFormDef :: HtmlFormDef ()
rdFormDef = simpleFormDef rdFormContents

-- Now we can embed the form into a web page:
main :: IO HtmlPage
main = return $
  page "String reverse/duplicate" [formElem rdFormDef]

-- Install the CGI program by:
-- curry2cgi -o revdup.cgi revdup
