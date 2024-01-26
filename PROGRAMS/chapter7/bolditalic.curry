-- Translate a text file into HMTL document where lines are set
-- in bold and italic:

import HTML.Base

-- Generate bold/italic lines from a list of text lines:
boldItalicLines :: [String] -> [BaseHtml]
boldItalicLines [] = []
boldItalicLines [line] = [bold [htxt line], breakline]
boldItalicLines (line1:line2:lines) =
  [bold [htxt line1], breakline, italic [htxt line2], breakline] ++
  boldItalicLines lines

-- Translate a text file into a HTML file:
boldItalic :: String -> String -> IO ()
boldItalic textfile htmlfile = do
  text <- readFile textfile
  writeFile htmlfile
            (showHtmlPage (page "Bold/Italic" (boldItalicLines (lines text))))

