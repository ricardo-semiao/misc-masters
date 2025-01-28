# Parâmetros
beta = 0.96**(1/6)  # Fator de desconto
sigma = 1.5  # Aversão ao risco
r_ano = 0.034  # Taxa de juros anual
#q = 1 / (1 + r)  # Preço dos ativos
tol = 1e-6  # Tolerância para convergência
max_iter = 1000  # Número máximo de iterações
r = (1+r_ano)**(1/6)-1

# Estados de produtividade (empregado e desempregado)
z = np.array([1, 0.1])  # z[0] = empregado, z[1] = desempregado

# Matriz de probabilidades de transição
pr = np.array([[0.925, 0.075], [0.5, 0.5]])

# Resolvendo para a distribuição estacionária
eigvals, eigvecs = np.linalg.eig(pr.T)
stationary = eigvecs[:, np.isclose(eigvals, 1)].flatten().real
stationary = stationary / stationary.sum()

# Calculando a renda média
average_income = np.dot(stationary, z)

print(average_income)

# Grade de ativos
N = 200  # Número de pontos no grid
a_l = -average_income  # Restrição de endividamento (renda de um ano)
a_h = 3 * average_income  # Limite superior (3 vezes a renda média)
a_grid = np.linspace(a_l, a_h, N)  # Grade de ativos




import numpy as np
import polars as pl
import matplotlib.pyplot as plt
import seaborn as sns


states = [0.1, 1]
n = 2

beta = 0.96
sigma = 1.5
probs = np.array([[0.5, 0.5], [0.925, 0.075]])
#r = 3.4

m = 200
tol = 0.001

om = np.ones((1, m)) #auxiliary ones vector

a = np.linspace(-2, 2, m).reshape(m, 1)
q_bounds = [(beta + tol), 2]
q = (np.sum(q_bounds)) / 2


def get_c(s, a, q, tol):
    c = np.ones((m, 1)) @ np.transpose(a + s) - q * a @ np.ones((1, m))
    c[c < 0] = tol
    return c

def get_u(c, sigma):
    return (c**(1 - sigma) - 1) / (1 - sigma)

def value_function(m, us, beta, om, tol, probs):
    check_vf = np.array([999, 999])
    vs = [np.zeros((m, 1)) for i in range(2)]
    tvs_partial = [0, 0]
    tvs = [np.transpose(np.max(us[i] + beta * vs[i] @ om, axis=1, keepdims=True))
        for i in range(2)]
    
    while np.max(check_vf) > tol:
        vs = tvs
        for i in range(2):
            tvs_partial[i] = us[i] + beta * (probs[i, 0] * vs[0] + probs[i, 1] * vs[1]) * om
            tvs[i] = np.max(tvs_partial[i], axis=1, keepdims=True)
            check_vf[i] = np.linalg.norm(tvs[i] - vs[i]) / np.linalg.norm(vs[i])

    return tvs_partial

def policy(tvs_partial, a, states, q):
    policy_a = [0, 0]
    policy_c = [0, 0]
    max_vf_ind = [0, 0]

    for i in range(2):
        max_vf_ind[i] = np.argmax(tvs_partial[i], axis=1)
        policy_a[i] = a[max_vf_ind[i], :]
        policy_c[i] = a + states[i] - q * policy_a[i]

    return max_vf_ind, policy_a, policy_c    

def markov(n, m, probs, max_vf_ind):
    mkprobs_aux = [None, None]
    mkprobs = np.zeros((n * m, n * m))
    
    for i in range(2):
        mkprobs_aux[i] = np.zeros((m, m))
        mkprobs_aux[i][:, max_vf_ind[i]] = 1
    
    for i in range(m):
        for j in range(m):
            mkprobs[i*2, 2*j] = probs[0, 0] * mkprobs_aux[0][i, j]
            mkprobs[i*2, 2*j+1] = probs[0, 1] * mkprobs_aux[0][i, j]
            mkprobs[i*2+1, 2*j] = probs[1, 0] * mkprobs_aux[1][i, j]
            mkprobs[i*2+1, 2*j+1] = probs[1, 1] * mkprobs_aux[1][i, j]

    return mkprobs

def distribution(n, m, mkprobs, tol):
    dist_prev = np.ones((1, n * m)) / (n * m)
    dist = dist_prev @ mkprobs
    iter_dist = 1
    
    while np.linalg.norm(dist - dist_prev) < tol:
        iter_dist += 1
        if iter_dist == 1000:
            sprintf('!!! Hit maximum amount of iterations on distribution step',)
            break
        dist_prev = dist
        dist = np.matmul(dist, mkprobs)

    return dist


security = 999
iter_total = 0

while abs(security) > tol:
    iter_total += 1
    print(f"Iteration: {iter_total} || sec = {security}, q = {q}")
    
    # Grids for consumption and utility:
    cs = [get_c(s, a, q, tol) for s in states]
    us = [get_u(c, sigma) for c in cs]

    # Value function iteration:
    tvs_partial = value_function(m, us, beta, om, tol, probs)
    
    # Optimal policy functions:
    max_vf_ind, policy_a, policy_c = policy(tvs_partial, a, states, q)

    # Endogenous Markov chains:
    mkprobs = markov(n, m, probs, max_vf_ind)

    # Distribution:
    dist = distribution(n, m, mkprobs, tol)
    
    # Security markets:
    anext = np.zeros((n * m, 1))
    
    for i in range(m):
        anext[i * 2, 0] = policy_a[0][i]
        anext[i * 2 + 1, 0] = policy_a[1][i]
    
    security = dist @ anext
    
    # Price updating:
    q_bounds[int(security[0][0] > 0)] = q
    q = np.sum(q_bounds) / 2
