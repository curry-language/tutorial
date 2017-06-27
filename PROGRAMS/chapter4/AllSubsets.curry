import SetFunctions

subset []     = []
subset (x:xs) = x:subset xs
subset (_:xs) =   subset xs

powerset set = set1 subset set

main = powerset [1,2,3]  -- -> SetFunctions.Values (Just [1,2,3]) [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]]

pp_main = sortValues main

