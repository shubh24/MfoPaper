import math
import numpy as np
import matplotlib.pyplot as plt
from pylab import plot, legend, subplot, grid, xlabel, ylabel, show, title
import random

def func(u):
    z = u**2
    return sum(z)

def simplebounds(s,lb,ub):
    d = np.shape(s)[0]

    for i in range(d - 1):
        if (s[i] - lb[i] < 0):
            s[i] = lb[i]

    for i in range(d - 1):
        if (s[i] - ub[i] > 0):
            s[i] = ub[i]
    return s

para = np.array([25, 1000, 1, 1])

n = int(para[0])
num_iter = int(para[1])
A = para[2]
r_range = para[3]

Qmin = 0
Qmax = 2

gamma = 1

d = 30

lb = -100*np.ones(d)
ub = +100*np.ones(d)

Q = np.zeros((n, 1))
r = np.random.rand(n,1)
v = np.zeros((n, d))

Sol = np.zeros((n, d))
S = np.zeros((n, d))
fitness = np.zeros((n, 1))

#print np.shape(Sol)[1]

for i in range(int(n)):
    Sol[i, :] = lb + np.multiply((ub-lb), (np.random.rand(1,d)))
    x = Sol[i,:]
    fitness[i] = func(x)

I = np.argmin(fitness)
best = Sol[I,:]
fmin = fitness[I]

for t in range(num_iter):
    for i in range(n):
        Q[i] = Qmin + (Qmax - Qmin) * random.random()
        v[i,:] = v[i,:] + (Sol[i,:] - best)*Q[i]
        S[i,:] = Sol[i,:] + v[i,:]
        S[i,:] = simplebounds(S[i,:], lb, ub)

        if random.random > r[i]:
            S[i,:] = best + 0.95*np.random.normal(1,d)
	
        fnew = func(S[i,:])

        if(fnew <= fitness[i] and random.random() < A):
            r[i] = r[i]*(1 - math.exp(-gamma*num_iter))
            Sol[i,:] = S[i,:]
            fitness[i] = fnew

        if(fnew <= fmin):
            best = S[i,:]
            fmin = fnew

print Sol
print fitness[np.argmin(fitness)]

'''x = Sol[:,0]
y = Sol[:,1]
plt.scatter(x,y,z)
plt.show()'''
