import SetRBT
import trie

-- A set of words
sample = [
  "aback",
  "abaft",
  "abandon",
  "abandoned",
  "abandoning",
  "abandonment",
  "abandons",
  "abase",
  "abased",
  "abasement",
  "abasements",
  "abases",
  "abash",
  "abashed",
  "abashes",
  "abashing",
  "zonal",
  "zonally",
  "zone",
  "zoned",
  "zones",
  "zoning",
  "zoo",
  "zoological",
  "zoologically",
  "zoom",
  "zooms"]

-- the same set in scrambed order
scrambled = map reverse (sortRBT precede (map reverse sample))
  where precede [] _ = True
        precede (_:_) [] = False
        precede (x:xs) (y:ys) 
           | ord x < ord y = True
           | ord y < ord x = False
           | otherwise     = precede xs ys

-- print the trie
pp trie = ppaux "" trie
  where ppaux s (Tree c []) | c == '.'  = [s]
                            | otherwise = []
        ppaux s (Tree c (x:xs)) = ppaux (s++[c]) x ++ ppaux s (Tree c xs)

-- build and print all the words in a trie
-- a share prefix is printed for each word sharing it
test = foldr (\x y -> pp x ++ y) [] (buildTrie scrambled)
