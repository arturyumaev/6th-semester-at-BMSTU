import pandas
import numpy

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

def compute_x(polynom, x):
    result = 0
    for p in polynom:
        result += (p.coef * x ** p.degree)

    return result

def func(x, y):
    return x ** 2 + y ** 2

def explicit(x, y, h):
    return (y + h * func(x, y));

def implicit(x, y, h):
    K1 = func(x, y);
    K2 = func(x + h / 2, y + h * K1 / 2);
    K3 = func(x + h / 2, y + h * K2 / 2);
    K4 = func(x + h, y + h * K3);
    return y + h / 6 * (K1 + 2 * K2 + 2 * K3 + K4);

# Define polynoms
pikar_n = 5

poly3 = y(3)
poly4 = y(4)
polyn = y(pikar_n)

h = 0.05

values = []
x = 0
y0 = 0
while x <= 1 + h:
    values.append([x,
                   compute_x(poly3, x),
                   compute_x(poly4, x),
                   compute_x(polyn, x),
                   explicit(x, y0, h),
                   implicit(x, y0, h)])
    x += h
    y0 = explicit(x, y0, h)

# Construct table
df = pandas.DataFrame(values, columns=['x', 'Pikar 3', 'Pikar 4', 'Pikar n={}'.format(pikar_n), 'explicit', 'implicit'])
print(df)
