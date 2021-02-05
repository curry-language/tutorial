----------------------------------------------------------------
--- Generate URLs for browsing all code examples and put them
--- into a LaTeX macro.
---
--- @author Michael Hanus
--- @version February 2021
----------------------------------------------------------------

import Directory
import List      ( isPrefixOf, isSuffixOf )
import HTML.Base ( string2urlencoded )

main :: IO ()
main = do
  subdirs <- getSubDirs "."
  let exdirs = filter ("chapter" `isPrefixOf`) subdirs
  fnames <- mapM getCurryFiles exdirs
  genMacroFile (concat fnames) "../browseurl.tex"

--- Gets all subdirectories of a directory.
getSubDirs :: String -> Prelude.IO [String]
getSubDirs dir = do
  names <- getDirectoryContents dir
  dirs <- mapM (\d -> do b <- doesDirectoryExist d
                         return (if b && head d /= '.' then [d] else []))
               names
  return (concat dirs)

--- Gets all Curry files in a directory
getCurryFiles :: String -> Prelude.IO [String]
getCurryFiles dir =
  getDirectoryContents dir >>= mapM getCurryFile >>= return . concat
 where
  getCurryFile f = do
    b <- doesFileExist (dir++'/':f)
    return $ if b && ".curry" `isSuffixOf` f then [dir ++ '/' : f]
                                             else []

-- The base URL of Smap:
smapBaseURL :: String
smapBaseURL = "https://smap.informatik.uni-kiel.de/smap.cgi"
--smapBaseURL = "http://localhost/mh/smap/smap.cgi"

-- The default programming language for uploaded programs:
uploadLanguage :: String
uploadLanguage = "curry"

-- Generate Smap URL for a given program.
generateURL :: String -> String
generateURL program =
  smapBaseURL ++ "?upload?lang=" ++ uploadLanguage
              ++ "&program=" ++ string2urlencoded program

--- Generates Smap URL for a given file name.
generateProgramURL :: String -> IO String
generateProgramURL progname = do
  program <- readFile progname
  return (generateURL program)

-- Generate a LaTeX file containing results of macro execution.
genMacroFile :: [String] -> String -> IO ()
genMacroFile fnames outfile = do
  s <- mapIO showMacro fnames
  writeFile outfile ("\\newcommand{\\progbrowseurl}[2]\n" ++
                     genResultMacro s ++ "\n")
  putStrLn $ "LaTeX macro definition written into file '" ++ outfile ++ "'"
 where
  showMacro f = do
    s <- generateProgramURL f
    return $ "\\ifthenelse{\\equal{#1}{" ++ f ++ "}}{\\href{" ++
             escapeLaTeX s ++ "}{#2}}\n"

  genResultMacro [] = "{\\{\\texttt{#1}\\}}\n"
  genResultMacro (t:ts) = "{" ++ t ++ "{" ++ genResultMacro ts ++ "}}"

-- Escape latex special characters:
escapeLaTeX :: String -> String
escapeLaTeX [] = []
escapeLaTeX (c:cs) | c=='%'    = '\\' : '%' : escapeLaTeX cs
                   | otherwise = c : escapeLaTeX cs

----------------------------------------------------------------
