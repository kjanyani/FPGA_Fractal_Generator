from intelhex import IntelHex
import numpy as np
from matplotlib import cm
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
ih=IntelHex("ram3_9.hex")
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
X=np.linspace(0,8,9)
Y=np.linspace(0,8,9)
X, Y = np.meshgrid(X, Y)
Z=np.empty([9,9])
k=0
for i in range (0,8):
	for j in range (0,8):
		Z[i,j]=ih[k]
		k=k+1
Z[0,0]=0
Z[1,0]=0
surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm,
                       linewidth=0, antialiased=False)
ax.set_zlabel('Height')
plt.show()

