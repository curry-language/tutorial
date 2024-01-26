------------------------------------------------------------------------------
-- Example for CGI programming in Curry: a questionnaire
------------------------------------------------------------------------------

import System.Directory ( doesFileExist, removeFile, renameFile )
import System.IOExts    ( exclusiveIO )
import HTML.Base

-- The question of the form:
question :: String
question = "Who is your favorite actress?"

-- The choices for the votes:
choices :: [String]
choices = ["Doris Day", "Jodie Foster", "Marilyn Monroe",
           "Julia Roberts", "Sharon Stone", "Meryl Streep"]

-- The name of the file where the current numbers of votes are stored:
voteFile :: String
voteFile = "votes.data"

-- Reads the vote file and return the votes in a list.
-- Initializes it if necessary.
readVoteFile :: IO [Int]
readVoteFile = do
  existnumfile <- doesFileExist voteFile
  if existnumfile
    then do vfcont <- readFile voteFile
            return (map read (lines vfcont))
    else do let nums = take (length choices) (repeat 0)
            writeFile voteFile (unlines (map show nums))
            return nums

-- Overwrites the vote file with a new list of votes.
overwriteVoteFile :: [Int] -> IO ()
overwriteVoteFile nums = do
  writeFile (voteFile ++ ".new") (unlines (map show nums))
  removeFile voteFile
  renameFile (voteFile ++ ".new") voteFile

-- Increments a number in the vote file.
incNumberInFile :: Int -> IO ()
incNumberInFile voteindex = do
  nums <- readVoteFile
  overwriteVoteFile (incNth nums voteindex)
 where
  -- increment n-th element in a list:
  incNth []     _             = []
  incNth (x:xs) n | n==0      = (x+1) : xs
                  | otherwise = x : incNth xs (n-1)

-- Form for voting:
questForm :: HtmlFormDef ()
questForm = simpleFormDef $
  [h1 [htxt question],
   radioMain vref "0", htxt (' ' : head choices), breakline] ++
   concatMap (\ (i,s) -> [radioOther vref (show i), htxt (' ':s), breakline])
             (zip [1..] (tail choices)) ++
   [hrule, button "submit" questHandler]
 where
   vref free

   questHandler env = do
     exclusiveIO (voteFile ++ ".lock")
                 (incNumberInFile (read (env vref)))
     evalPage

-- HTML page showing the current votes:
evalPage :: IO HtmlPage
evalPage = do
  votes <- exclusiveIO (voteFile ++ ".lock") readVoteFile
  return $ page "Evaluation"
   [h1 [htxt "Current votes:"],
    table (map (\(s,v) -> [[htxt s], [htxt $ show v]])
               (zip choices votes))]

-- Voting page:
main :: IO HtmlPage
main = return $ page "Vote Form" [formElem questForm]

-- Install the CGI program by:
-- curry2cgi -o quest.cgi questionnaire
