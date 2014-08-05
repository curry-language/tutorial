data BinTree a = Leaf | Branch a (BinTree a) (BinTree a)

insert x Leaf = Branch x Leaf Leaf
insert x (Branch d l r)
  | x < d = Branch d (insert x l) r
  | x > d = Branch d l (insert x  r)
  | otherwise = Branch d l r

inorder Leaf = []
inorder (Branch d l r) = inorder l ++ [d] ++ inorder r
