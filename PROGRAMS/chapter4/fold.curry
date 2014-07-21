import Integer

sumList = foldr (+) 0
prodList = foldr (*) 1
maxList = \l -> foldr max (head l) (tail l)

-- sumList  [1,2,3,4,5] =>  15
-- prodList [1,2,3,4,5] => 120
-- maxList  [1,2,3,4,5] =>   5

