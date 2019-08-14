-- Web script to show the current date and time of the server

import HTML.Base
import Time

-- A form that generates the HTML document on demand:
main :: IO HtmlForm
main = do
  time <- getLocalTime
  return $ form "Current Server Time"
            [h1 [htxt $ "Current date and time: " ++ calendarTimeToString time]]

-- Install the script by:
-- curry-makecgi -o servertime.cgi servertime
