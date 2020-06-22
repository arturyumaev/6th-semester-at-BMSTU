# -*- coding: utf-8 -*-

import numpy
import matplotlib.pyplot as plt
from math import fabs

def k(T_num):
    return a1 * (b1 + c1 * (T_num**m1))

def c(T_num):
    return a2 + b2 * T_num**m2 - c2/(T_num**2)

def alpha(x):
    return c_coef / (x - d)

def p(x):
    return 2/R * alpha(x)

def f(x):
    return 2*T0/R * alpha(x)


def An(T_num, h):
    k_minus = (k(T_num - tao) + k(T_num)) / 2
    return tao/h * k_minus

def Bn(T_num, Ai, Di, xi, h):
    return Ai + Di + c(T_num)*h + p(xi)*h*tao

def Dn(T_num, h):
    k_plus = (k(T_num + tao) + k(T_num)) / 2
    return tao/h * k_plus

def Fn(T_num, xi, h):
    return f(xi) * h * tao + c(T_num) * T_num * h


def getK0(T_start, h):
    k_plus = (k(T_start + tao) + k(T_start)) / 2
    c0_half = (c(T_start) + c(T_start + tao)) / 2
    pn_half = p(h/2)
    return h/8 * c0_half + h/4 * c(T_start) + tao/h * k_plus + tao*h/8 * pn_half + tao*h/4 * p(x0)

def getM0(T_start, h):
    k_plus = (k(T_start + tao) + k(T_start)) / 2
    c0_half = (c(T_start) + c(T_start + tao)) / 2
    pn_half = p(h/2)
    return h/8 * c0_half - tao/h * k_plus + tao * h/8 * pn_half

def getP0(T_start, h):
    c0_half = (c(T_start) + c(T_start + tao)) / 2
    return h/8 * c0_half * (T_old[0] + T_old[1]) + h/4 * c(T_start) * T_start \
        + F0 * tao \
        + tao * h/8 * (3 * f(x0) + f(h))

def getKN(T_end, h):
    k_minus = (k(T_end - tao) + k(T_end)) / 2
    cn_half = (c(T_end) + c(T_end - tao)) / 2
    pn_half = p(l - h/2)
    return h/4 * c(T_end) \
        + h/8 * cn_half \
        + tao*h/4 * p(l) \
        + tao*h/8 * pn_half \
        + tao * alphaN \
        + tao/h * k_minus

def getMN(T_end, h):
    k_minus = (k(T_end - tao) + k(T_end)) / 2
    cn_half = (c(T_end) + c(T_end - tao)) / 2
    pn_half = p(l - h/2)
    return h/8 * cn_half \
        + tao*h/8 * pn_half \
        - tao/h * k_minus

def getPN(T_end, h):
    cn_half = (c(T_end) + c(T_end - tao)) / 2
    fn_half = f(l - h / 2)
    return h/4 * c(T_end) * T_old[-1] \
        + alphaN * T0 * tao \
        + h/4 * tao * (f(l) + fn_half) \
        + h/8 * cn_half * (T_old[-1] + T_old[-2])

def progonka(A, B, C, D, K0, M0, P0, KN, MN, PN):
    xi = [0]
    eta = [0]
    xi.append(-M0 / K0)
    eta.append(P0 / K0)

    for i in range(1, len(A)):
        xi.append(C[i] / (B[i] - A[i] * xi[-1]))
        eta.append((D[i] + A[i] * eta[-1]) / (B[i] - A[i] * xi[-2]))

    y = [(PN - MN * eta[-1]) / (KN + MN * xi[-1])]
    for i in range(len(A) - 2, -1, -1):
        y.append(xi[i] * y[-1] + eta[i])

    y.reverse()

    return y


def do_plot(masx, masy, xlabel, ylabel):
    plt.plot(masx, masy)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.grid(True)

def calc_changes(a, b):
    lb = len(b)
    la = len(a)

    if lb > la:
        a, b = b, a

    la = len(a)

    diff = []
    for i in range(la):
        if i < lb:
            diff.append(fabs(b[i] - a[i]))
        else:
            diff.append(a[i])
    
    return diff


if __name__ == "__main__":
    a1 = 0.0134
    b1 = 1
    c1 = 4.35 * 1e-4
    m1 = 1
    a2 = 2.049
    b2 = 0.563 * 1e-3
    c2 = 0.528 * 1e+5
    m2 = 1

    alpha0 = 0.05
    alphaN = 0.01

    l = 10
    T0 = 300
    R = 0.5
    F0 = 50

    x0 = 0
    h = 1e-2
    tao = 1

    d = alphaN * l / (alphaN - alpha0)
    c_coef = - alpha0 * d

    T = [T0 for x in numpy.arange(x0, l + h, h)]
    time = 0
    mas_x = [x for x in numpy.arange(x0, l + h, h)]
    mas_t = [0]
    do_plot(mas_x[1:], T[1:], 'Length (cm)', 'Temperature (K)')
    T_global = [T[:]]

    A = []
    D = []
    B = []
    F = []

    k_i = 0
    while True:
        T_old = T[:]
        A.clear()
        B.clear()
        D.clear()
        F.clear()
        i = 0
        for x in numpy.arange(x0, l + h, h):
            Ai = An(T_old[i], h)
            Di = Dn(T_old[i], h)
            Bi = Bn(T_old[i], Ai, Di, x, h)
            Fi = Fn(T_old[i], x, h)

            A.append(Ai)
            D.append(Di)
            B.append(Bi)
            F.append(Fi)
            i += 1

        K0 = getK0(T_old[0], h)
        M0 = getM0(T_old[0], h)
        P0 = getP0(T_old[0], h)

        KN = getKN(T_old[-1], h)
        MN = getMN(T_old[-1], h)
        PN = getPN(T_old[-1], h)

        T = progonka(A, B, D, F, K0, M0, P0, KN, MN, PN)
        T[0] = T[1]

        diff = calc_changes(T, T_old)
        maxDiff = max(diff)
        if fabs(maxDiff / T[diff.index(maxDiff)]) < 1e-4:
            T_global.append(T[:])
            time += tao
            mas_t.append(time)
            do_plot(mas_x[1:], T[1:], 'Length (cm)', 'Temperature (K)')
            break

        if k_i % 10 == 0:
            do_plot(mas_x[1:], T[1:], 'Length (cm)', 'Temperature (K)')

        T_global.append(T[:])
        time += tao
        mas_t.append(time)
        k_i += 1

    plt.show()


    matrix = []
    for i in range(len(T_global[0])):
        matrix.append([])

    for i in range(len(T_global)):
        for j in range(len(T_global[i])):
            matrix[j].append(T_global[i][j])

    for i in range(len(matrix)):
        if (i % 10 == 0):
            do_plot(mas_t, matrix[i], 'Time (sec)', 'Temperature (K)')
    plt.show()
