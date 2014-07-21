sumlist :: [Int] -> Int
sumlist []    = 0
sumlist (u:v) = u + sumlist v

-- sumlist [0,1,2,3,4,5,6,7,8,9] => 45

