import numpy as np
import random
import math

data = []

with open("../data/ks_45_0","rb") as f:
    data = [[int(x) for x in line.split()] for line in f]

ess = data[0]
dat = data[1 :]

print ess
print dat

def fitness(v, ess, dat):
    cost = 0
    wt = 0
    for i in range(len(v)):
        cost = cost + v[i]*dat[i][0]
        wt = wt + v[i]*dat[i][1]
    if wt > ess[1]:
        return [0, wt]
    return np.array([cost, wt])

v1 = np.array([0, 1, 1, 1])
x =  fitness(v1, ess, dat)

def bound(v, ess, dat):
    ones = []
    ones = [i for i in range(len(v)) if v[i] == 1]
    s = fitness(v, ess, dat)
    w = s[1]
    d = w - ess[1]
    if len(ones) == 0:
        return v
    while(d > 0):
        i = random.choice(ones)
        d = d - dat[i][1]
        v[i] = 0

    return v

###################################################################################

para = np.array([25, 200, 1, 1])

n = int(para[0])
num_iter = int(para[1])
A = para[2]
r_range = para[3]

Qmin = 0
Qmax = 2

gamma = 1

d = ess[0]

Q = np.zeros((n, 1))
r = np.random.rand(n,1)
v = np.zeros((n, d))

Sol = np.zeros((n, d))
S = np.zeros((n, d))
fitness_val = np.zeros((n, 1))

for i in range(int(n)):
    for j in range(ess[0]):
        if random.random() > 0.5:
            Sol[i,j] = 0
        else:
            Sol[i,j] = 1
    fitness_val[i] = fitness(Sol[i,:], ess, dat)[0]

print fitness_val

I = np.argmax(fitness_val)
best = Sol[I,:]
fmax = fitness_val[I]
print "best ="
print best

for t in range(num_iter):
    for i in range(n):
        bound(Sol[i,:], ess, dat)
        for j in range(ess[0]):
            Q[i] = Qmin + (Qmax - Qmin) * random.random()
            v[i,j] = v[i,j] + (Sol[i,j] - best[j])*Q[i]

            transfer_function = 1/(1+math.exp(-v[i,j]))

            if transfer_function > 0.5:
                Sol[i,j] = np.logical_xor(Sol[i,j], 1)

            if random.random > r[i]:
                fnew = fitness(S[i,:], ess, dat)[0]

            if(fnew >= fitness_val[i] and random.random() < A):
                r[i] = r[i]*(1 - math.exp(-gamma*num_iter))

                Sol[i,:] = S[i,:]
                fitness_val[i] = fnew

                if(fnew >= fmax):
                    best = S[i,:]
                    fmax = fnew

print "hello"
print best
print fitness_val[np.argmax(fitness_val)]
