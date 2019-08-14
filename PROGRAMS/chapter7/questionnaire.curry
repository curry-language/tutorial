------------------------------------------------------------------------------
-- Example for CGI programming in Curry: a questionnaire
------------------------------------------------------------------------------

import Directory ( doesFileExist, removeFile, renameFile )
import IOExts    ( exclusiveIO )
import HTML.Base

-- The parameters of the form:
question :: String
question = "Who is your favorite actress?"

choices :: [String]
choices = ["Doris Day", "Jodie Foster", "Marilyn Monroe",
           "Julia Roberts", "Sharon Stone", "Meryl Streep"]

-- Form for voting:
questForm :: IO HtmlForm
questForm = return $ form "Vote Form" $
  [h1 [htxt question],
    radio_main vref "0", htxt (' ':head choices), breakline] ++
   concatMap (\ (i,s) -> [radio_other vref (show i), htxt (' ':s), breakline])
             (zip [1..] (tail choices)) ++
   [hrule, button "submit" questHandler]
 where
   vref free

   questHandler env = do
     exclusiveIO (voteFile ++ ".lock")
                 (incNumberInFile (read (env vref)))
     evalForm

-- Form for evaluating current votes:
evalForm :: IO HtmlForm
evalForm = do
  votes <- exclusiveIO (voteFile ++ ".lock") readVoteFile
  return $ form "Evaluation"
   [h1 [htxt "Current votes:"],
    table (map (\(s,v)->[[htxt s],[htxt $ show v]])
               (zip choices votes))]


-- increment n-th element in a list:
incNth :: [Int] -> Int -> [Int]
incNth []     _ = []
incNth (x:xs) n | n==0      = (x+1) : xs
                | otherwise = x : incNth xs (n-1)

-- increment a number in the vote file:
incNumberInFile :: Int -> IO ()
incNumberInFile n = do
  initVoteFile (length choices)
  nums <- readVoteFile
  overwriteVoteFile (incNth nums n)

-- initialize data file if necessary:
initVoteFile :: Int -> IO ()
initVoteFile n = do
  existnumfile <- doesFileExist voteFile
  unless existnumfile $
    writeFile voteFile (unlines (map show (take n (repeat 0))))

-- read the vote file with lines containing numbers and return them in a list:
readVoteFile :: IO [Int]
readVoteFile = do
  vfcont <- readFile voteFile
  return (map read (lines vfcont))


-- overwrite the vote file with a new list of numbers (each number into a line):
overwriteVoteFile :: [Int] -> IO ()
overwriteVoteFile nums = do
  writeFile (voteFile ++ ".new") (unlines (map show nums))
  removeFile voteFile
  renameFile (voteFile ++ ".new") voteFile

-- the file where the current numbers of votes are stored:
voteFile :: String
voteFile = "votes.data"


-- Install the CGI program by:
-- curry-makecgi -o quest.cgi -m questForm questionnaire
