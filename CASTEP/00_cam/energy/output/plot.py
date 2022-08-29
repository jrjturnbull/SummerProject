import sys
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(100, 700, 61)
y = []
filein = open('{}.dat'.format(sys.argv[1]))
for line in filein.readlines():
    y.append(float(line))
filein.close()
plt.plot(x, y)
plt.show()