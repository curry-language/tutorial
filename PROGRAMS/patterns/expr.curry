import SetFunctions

-- the type of simple symbolic arithmetic expressions
data Exp = Lit Int
         | Var [Char]
         | Add Exp Exp
         | Mul Exp Exp

-- generate an expression containing the argument as a subexpression
withSub exp = exp
            ? op (withSub exp) unknown
            ? op unknown (withSub exp)
   where op = Add ? Mul  

-- get the identifier of a variable occurring in the argument
varOf (withSub (Var v)) = v

-- sample expression
sample = Add (Var "x") (Mul (Lit 1) (Var "y"))

-- gete the set of the idenfiers occurring in the argument
main = set1 varOf sample
