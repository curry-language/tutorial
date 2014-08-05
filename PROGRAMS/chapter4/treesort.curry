import binsearchtree

testdata = [9,2,6,3,5,4,1,7,8,0]

main = inorder (list2bst testdata)
     where list2bst [] = Leaf
     	   list2bst (x:xs) = insert x (list2bst xs)
