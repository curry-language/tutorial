data Width = C | D | E | EE | EEE

largest :: String -> (Int,Width)
largest "New Balance 495" = (13,EEE)
largest "Adidas Comfort"  = (13,E)
