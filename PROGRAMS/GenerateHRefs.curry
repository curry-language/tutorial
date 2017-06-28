----------------------------------------------------------------
--- Generate URLs for browsing all code examples and put them
--- into a LaTeX macro.
---
--- @author Michael Hanus
--- @version July 2014
----------------------------------------------------------------

import ReadShowTerm(readQTerm)
import Char(isDigit)
import List(intercalate)
import IO
import System
import Directory
import FileGoodies
import Distribution(installDir,curryCompiler)
import HTML(string2urlencoded)

main :: IO ()
main = do
  subdirs <- getSubDirs "."
  let exdirs = filter (\d -> take 7 d == "chapter") subdirs
  fnames <- mapIO getCurryFiles exdirs
  genMacroFile (concat fnames) "../browseurl.tex"

--- Gets all subdirectories of a directory.
getSubDirs :: String -> Prelude.IO [String]
getSubDirs dir = do
  names <- getDirectoryContents dir
  dirs <- mapIO (\d -> doesDirectoryExist d >>= \b ->
                       return (if b && head d /= '.' then [d] else [])) names
  return (concat dirs)

--- Gets all Curry files in a directory
getCurryFiles :: String -> Prelude.IO [String]
getCurryFiles dir = do
  names <- getDirectoryContents dir
  fs <- mapIO (\f -> doesFileExist (dir++'/':f) >>= \b -> return
            (if b && take 6 (reverse f) == "yrruc." then [dir++'/':f] else []))
              names
  return (concat fs)

-- The base url of Smap:
smapBaseUrl :: String
smapBaseUrl = "http://www-ps.informatik.uni-kiel.de/smap/smap.cgi"
--smapBaseUrl = "http://localhost/mh/smap/smap.cgi"

-- The default programming language for uploaded programs:
uploadLanguage :: String
uploadLanguage = "curry"

-- Generate Smap URL for a given program.
generateURL :: String -> String
generateURL program =
  smapBaseUrl ++ "?upload?lang=" ++ uploadLanguage
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
  writeFile outfile ("\\newcommand{\\progbrowseurl}[2]\n"++genResultMacro s++"\n")
  putStrLn $ "LaTeX macro definition written into file '"++outfile++"'"
 where
  showMacro f = do
    s <- generateProgramURL f
    return ("\\ifthenelse{\\equal{#1}{" ++f ++ "}}{\\href{" ++ escapeLaTeX s ++"}{#2}}\n")

  genResultMacro [] = "{\\{\\texttt{#1}\\}}\n"
  genResultMacro (t:ts) = "{"++t++"{"++genResultMacro ts++"}}"

-- Escape latex special characters:
escapeLaTeX :: String -> String
escapeLaTeX [] = []
escapeLaTeX (c:cs) | c=='%' = '\\' : '%' : escapeLaTeX cs
                   | otherwise = c : escapeLaTeX cs

----------------------------------------------------------------
