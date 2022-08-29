import matplotlib.pyplot as plt
from numpy import genfromtxt

my_data = genfromtxt('N2.T', delimiter=' ')
x = my_data.transpose()[0]
y = my_data.transpose()[1]
plt.plot(x,y)
plt.show()
