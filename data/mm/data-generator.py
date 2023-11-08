import random as rd
import os

row_a = 50
col_a = 50
col_b = 50

# floating point
matrix_a = [[rd.uniform(0.0, 100.0) for _ in range(col_a)] for _ in range(row_a)]
matrix_b = [[rd.uniform(0.0, 100.0) for _ in range(col_b)] for _ in range(col_a)]
result = [[0.0] * col_b for _ in range(row_a)]

# int
# matrix_a = [[rd.randint(1, 5) for _ in range(col_a)] for _ in range(row_a)]
# matrix_b = [[rd.randint(1, 5) for _ in range(col_b)] for _ in range(col_a)]
# result = [[0] * col_b for _ in range(row_a)]

for i in range(row_a):
    for j in range(col_b):
        for k in range(col_a):
            result[i][j] += matrix_a[i][k] * matrix_b[k][j]


directory_path = f'{row_a}-{col_a}-{col_b}'
try:
    os.makedirs(directory_path)
except:
    pass


matrix_a_path = f'{directory_path}/a.txt'
with open(matrix_a_path, 'w') as file:
    for row in matrix_a:
        row_str = ' '.join([str(n) for n in row])
        file.write(row_str + '\n')
            
matrix_b_path = f'{directory_path}/b.txt'
with open(matrix_b_path, 'w') as file:
    for row in matrix_b:
        row_str = ' '.join([str(n) for n in row])
        file.write(row_str + '\n')
            
result_path = f'{directory_path}/c.txt'
with open(result_path, 'w') as file:
    for row in result:
        row_str = ' '.join([str(n) for n in row])
        file.write(row_str + '\n')