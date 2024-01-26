-- Web script to show the current date and time of the server

import Data.Time  -- from package `time`
import HTML.Base  -- from package `html2`

-- Example: an HTML page to show the current time.
main :: IO HtmlPage
main = do
  time <- getLocalTime
  return $ page "Current Server Time"
    [h1 [htxt $ "Current date and time: " ++ calendarTimeToString time]]

-- Install the script by:
-- curry2cgi -o servertime.cgi servertime
