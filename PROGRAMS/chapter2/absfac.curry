abs x = if x>=0 then x else -x

fac n = if n==0 then 1
                else n * fac(n-1)
