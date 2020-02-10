class Polynom:
    def __init__(self, coef, degree):
        self.coef = coef
        self.degree = degree

def mult_poly(arr):
    # arr: [polynom1, polynom2, ...]
    # (a + b)^2 = (a + b)(a + b) = a*a + a*b + b*a + b*2

    elements = []

    # Multiplying
    for l_i in arr:
        for r_j in arr:
            new_coef = l_i.coef * r_j.coef
            new_degree = l_i.degree + r_j.degree
            new_poly = Polynom(new_coef, new_degree)
            elements.append(new_poly)

    return elements

def integrate(arr):

    t2 = Polynom(1, 2)

    arr = [t2] + arr
    
    integrated = []

    for p in arr:
        new_poly = Polynom(p.coef / (p.degree + 1), p.degree + 1)
        integrated.append(new_poly)

    return integrated

def y(n):
    # Starting point
    x = Polynom(0, 0) # coef=1, degree=1

    multiplied = [x]

    for i in range(n):
        multiplied_new = mult_poly(multiplied)
        integrated_new = integrate(multiplied_new)

        multiplied = integrated_new

    result = []
    for p in multiplied:
        if p.coef != 0:
            result.append(p)

    return result

result = y(3)

for p in result:
    print("Polynom degree:{} and coef:{}".format(p.degree, p.coef))


