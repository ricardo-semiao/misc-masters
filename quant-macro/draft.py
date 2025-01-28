import numpy as np
#import polars as pl

from time import time
from quantecon.markov import approximation as quant
from scipy.interpolate import interp1d

#import plotnine as gg
#from plotnine import ggplot, aes

#gg.theme_set(gg.theme_bw())
np.random.seed(12850281)



def markov_chain_simulate(p, z, n_periods, init = 0):
    # Containers:
    n_p = p.shape[0]
    states_simulated = np.zeros(n_periods)
    state_current = init

    # Simulate states:
    for t in range(n_periods):
        states_simulated[t] = z[state_current]
        state_current = np.random.choice(n_p, p = p[state_current])

    return states_simulated



def value_function_iterate():
    # Containers:
    v = np.zeros((n_grid_a, n_grid_z))
    policy_a = np.zeros_like(v)
    policy_c = np.zeros_like(v)

    t0 = time()
    for iter in range(n_iter):
        v_new = np.zeros_like(v)

        for ia, a in enumerate(a_grid):
            for iz, z in enumerate(z_grid):
                # Consumption and utility:
                cs = np.maximum((1 + r) * a + w * z - a_grid, 1e-6)
                us = np.where(cs > 0, (cs ** (1 - sigma)) / (1 - sigma), -np.inf)

                # Updating value:
                continuation = np.dot(p[iz], v.T)
                values = us + beta * continuation

                # Storing results:
                v_new[ia, iz] = np.max(values)
                policy_a[ia, iz] = a_grid[np.argmax(values)]
                policy_c[ia, iz] = cs[np.argmax(values)]

        # Convergence check:    
        if np.max(np.abs(v_new - v)) < tol:
            return (np.argmax(values), policy_a, policy_c, iter, time() - t0)
        
        v = v_new.copy() #else, update v
    
    return None  
    
    

# Main parameters:
delta = 0.08
beta = 0.96
alpha = 0.4
phi = 0
rho = 0.98
sigma = 2

# Variability parameter:
sigma_z = np.sqrt(0.621)
sigma_e = np.sqrt((sigma_z ** 2) * (1 - rho ** 2))

# Iteration utilities:
tol = 1e-6
n_iter = 1000



n_grid_z = 7
n_periods = 10000

result_tauchen = quant.tauchen(n_grid_z, rho, sigma_e, mu = 0, n_std = 3)

p = result_tauchen.P
z_grid_log = result_tauchen.state_values
z_grid = np.exp(z_grid_log)


#markov_z = markov_chain_simulate(p, z_grid_log, n_periods)
#markov_z_exp = markov_chain_simulate(p, z_grid, n_periods)


r = 0.02
w = (1 - alpha) * (alpha / r) ** (alpha / (1 - alpha))
#
n_grid_a = 250
#
a_grid = np.linspace(phi, 200, n_grid_a)

#res = value_function_iterate()


def edm_iterate(beta):
    # Containers:
    policy_a = np.zeros((n_grid_a, n_grid_z))
    policy_c = np.zeros((n_grid_a, n_grid_z))

    t0 = time()
    for iz, z in enumerate(z_grid):
        ap = a_grid.copy()
        cp = (1 + r) * ap + w * z
 
        for iter in range(n_iter):
            up_cp = np.zeros((n_grid_a, n_grid_z))
            for izp, zp in enumerate(z_grid):
                up_cp[:, izp] = ((1 + r) * ap + w * z) ** (-sigma)
            
            up_cp_expected = np.zeros(n_grid_a)
            for ia, a in enumerate(a_grid):
                up_cp_expected[ia] = np.dot(p[iz, :], up_cp[ia, :])
            
            c = (beta * (1 + r) * up_cp_expected) ** (-1 / sigma)
            a = (c + ap - w * z) / (1 + r)

            a_mono = np.maximum(a, a_grid[0])
            cp = interp1d(a_mono,
                c, fill_value = 'extrapolate', bounds_error = False
            )(ap)

            # Convergence check:    
            if iter == n_iter - 1 or np.max(np.abs(cp - c)) < tol:
                policy_a[:, iz] = ap
                policy_c[:, iz] = cp
        
    return  {
                'a': policy_a,
                'c': policy_c,
                'time': time() - t0
            }  

result_edm1 = edm_iterate(beta)
