-- Package `setfunctions` required, i.e., install this dependency by
--     > cypm add setfunctions
import Control.SetFunctions

subset :: [a] -> [a]
subset []     = []
subset (x:xs) = x:subset xs
subset (_:xs) =   subset xs

powerset :: [a] -> Values [a]
powerset set = set1 subset set

pow123 :: Values [Int]
pow123 = powerset [1,2,3]  -- -> {[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]}

main :: [[Int]]
main = sortValues pow123

