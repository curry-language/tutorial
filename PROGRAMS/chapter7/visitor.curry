------------------------------------------------------------------------------
-- Example for CGI programming in Curry:
-- A CGI program counting the number of visitors as a simple example
-- for updating information on the server by clients.
------------------------------------------------------------------------------

import Directory ( doesFileExist, removeFile, renameFile )
import HTML.Base

visitorForm :: IO HtmlForm
visitorForm = do
  visitnum <- incVisitNumber
  return $ form "Access Count Form"
           [h1 [htxt $ "You are the " ++ show visitnum ++ ". visitor!"]]

-- Increment the current visitor number and return the new number:
incVisitNumber :: IO Int
incVisitNumber = do
 existnumfile <- doesFileExist visitFile
 if existnumfile
   then do vfcont <- readFile visitFile
           overwriteVisitFile (read vfcont + 1)
   else do writeFile visitFile "1"
           return 1

overwriteVisitFile :: Int -> IO Int
overwriteVisitFile n = do
  writeFile (visitFile++".new") (show n)
  removeFile visitFile
  renameFile (visitFile ++ ".new") visitFile
  return n

-- the file where the current visitor number is stored:
visitFile :: String
visitFile = "numvisit"

-- Install the CGI program by:
-- curry-makecgi -o visitor.cgi -m visitorForm visitor
