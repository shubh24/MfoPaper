import csv
import numpy as np
import os
from os import listdir

files = os.listdir('.')
csvs = []
dims = []

for i in files:
    if i[-4:] == ".csv":
        csvs.append(i)
        dims.append(i[-9:-4])


res = [[] for i in range(0,len(csvs)+1,1)]
res[0].append("Dimensions")
res[0].append("FLY_Mean")
res[0].append("FLY_SD")
res[0].append("VShaped_Mean")
res[0].append("VShaped_SD")
res[0].append("SShaped_Mean")
res[0].append("SShaped_SD")

for x in range(0,len(csvs),1):
    f = open(csvs[x])
    re = csv.reader(f)

    first = []
    second = []
    third = []

    for i in re:
        first.append(int(i[0]))
        second.append(int(i[1]))
        third.append(int(i[2]))

    
    res[x+1].append(dims[x])

    f_mean = np.mean(first)
    f_sd = np.std(first)
    res[x+1].append(f_mean)
    res[x+1].append(f_sd)

    s_mean = np.mean(second)
    s_sd = np.std(second)
    res[x+1].append(s_mean)
    res[x+1].append(s_sd)

    t_mean = np.mean(third)
    t_sd = np.std(third)
    res[x+1].append(t_mean)
    res[x+1].append(t_sd)
    

g = open('table.csv','w')
w = csv.writer(g)

for i in res:
    w.writerow(i)
