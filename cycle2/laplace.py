import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
#defines initial state
top_voltage = 100
side = 20
first_line = [top_voltage]*side
middle_lines = [0]*side
state = []
state.append(first_line)
for i in range(1, side):
    state.append(middle_lines[:])

control_fator = 0
#while(control_fator<0.5):
for t in range(40000):
    previous_state = state
    for i in range(1,len(state)-1):
        for j in range(1,len(state[0])-1):
            r = 1/4*(state[i+1][j]+state[i-1][j]+state[i][j+1]+state[i][j-1]) - state[i][j]
            state[i][j] += r
#    control_fator = max(abs(state[i][j] - previous_state[i][j]) for i in range(1, len(state) - 1) for j in range(1, len(state[0]) - 1))

state_array = np.array(state)

x = np.linspace(0, side-1, side)
y = np.linspace(0, side-1, side)
X, Y = np.meshgrid(x, y)
print(state_array)

plt.figure(figsize=(6, 6))
plt.contourf(X, Y, state_array, levels=50, cmap='inferno')
plt.colorbar(label='Potencial')
plt.title('Mapa de Calor do Campo Elétrico')
plt.xlabel('x')
plt.ylabel('y')
plt.grid(True)
plt.show()

fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection='3d')

ax.plot_surface(X, Y, state_array, cmap='inferno', edgecolor='none')

# Adiciona rótulos e título
ax.set_title('Gráfico 3D do Campo Elétrico')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('Potencial')

plt.show()