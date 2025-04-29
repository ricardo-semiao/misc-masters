# Imports
import numpy as np
import pandas as pd
import scipy.stats as stats
from numpy.linalg import inv
from scipy.linalg import solve
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde
from statsmodels.graphics.tsaplots import plot_acf
import seaborn as sns
from tqdm import tqdm
from numpy.linalg import eigvals

# Load data
file_path = "G:/Meu Drive/Mestrado/5 Tri/Bayesian/PSET2/Code/Yields_Bloomberg.xlsx"
real_data = pd.read_excel(file_path, index_col=0)

# Map columns to maturities
maturity_map = {
    "TREASURY0,25": 3, "TREASURY0,5": 6, "TREASURY0,75": 9, "TREASURY1": 12,
    "TREASURY1,25": 15, "TREASURY1,5": 18, "TREASURY1,75": 21, "TREASURY2": 24,
    "TREASURY2,5": 30, "TREASURY3": 36, "TREASURY4": 48, "TREASURY5": 60,
    "TREASURY6": 72, "TREASURY7": 84, "TREASURY8": 96, "TREASURY9": 108,
    "TREASURY10": 120, "TREASURY15": 180, "TREASURY20": 240, "TREASURY30": 360
}
real_data = real_data[[col for col in maturity_map.keys()]]
taus = np.array([maturity_map[col] for col in real_data.columns])
yields = real_data.to_numpy()[:200]
T, N = yields.shape

# NS loadings
def nelson_siegel_loadings(taus, lambd):
    L = np.zeros((len(taus), 3))
    for i, tau in enumerate(taus):
        L[i, 0] = 1
        L[i, 1] = (1 - np.exp(-lambd * tau)) / (lambd * tau)
        L[i, 2] = L[i, 1] - np.exp(-lambd * tau)
    return L

# FFBS
def ffbs_stable(yields, L, A, mu, Q, H):
    T, N = yields.shape
    m = 3
    betas = np.zeros((T, m))
    P = np.zeros((T, m, m))
    beta_pred = mu
    P_pred = Q
    I = np.eye(m)
    for t in range(T):
        y_t = yields[t]
        S = L @ P_pred @ L.T + H + 1e-6 * np.eye(N)
        K = solve(S, L @ P_pred.T, assume_a='pos').T
        beta_filt = beta_pred + K @ (y_t - L @ beta_pred)
        P_filt = (I - K @ L) @ P_pred
        betas[t] = beta_filt
        P[t] = P_filt
        if t < T - 1:
            beta_pred = mu + A @ (beta_filt - mu)
            P_pred = A @ P_filt @ A.T + Q
    beta_draws = np.zeros((T, m))
    beta_draws[-1] = np.random.multivariate_normal(betas[-1], P[-1] + 1e-6 * I)
    for t in reversed(range(T-1)):
        P_f = P[t]
        J = P_f @ A.T @ inv(A @ P_f @ A.T + Q + 1e-6 * I)
        mean = betas[t] + J @ (beta_draws[t+1] - mu - A @ (betas[t] - mu))
        cov = P_f - J @ A @ P_f
        beta_draws[t] = np.random.multivariate_normal(mean, cov + 1e-6 * I)
    return beta_draws

# Bayesian sampling of mu, A, Q
def sample_mu_A_Q_bayesian(betas):
    mu_prior_mean = np.array([6.0, -2.5, -1.3])
    mu_prior_cov = np.diag([2.5**2, 1.5**2, 2.7**2])
    nu_Q = 5
    S_Q = np.eye(3)
    A0 = np.eye(3)
    Sigma_A = 0.01 * np.eye(3)
    T = betas.shape[0]
    X = betas[:-1]
    Y = betas[1:]
    Xc = X - X.mean(axis=0)
    Yc = Y - Y.mean(axis=0)
    Sxy = Xc.T @ Yc
    Sxx = Xc.T @ Xc
    A_hat = Sxy @ inv(Sxx + 1e-6 * np.eye(3))
    residuals = Yc - Xc @ A_hat
    S = residuals.T @ residuals
    Q_post = stats.invwishart.rvs(df=nu_Q + T - 1, scale=S + S_Q)
    precision_prior = inv(mu_prior_cov)
    precision_lik = T * inv(Q_post)
    cov_post = inv(precision_prior + precision_lik)
    mean_lik = inv(Q_post) @ (Y.mean(axis=0) - A_hat @ X.mean(axis=0))
    mean_post = cov_post @ (precision_prior @ mu_prior_mean + precision_lik @ mean_lik)
    mu_post = np.random.multivariate_normal(mean_post, cov_post)
    Xc = X - mu_post
    Yc = Y - mu_post
    V_n = inv(inv(Sigma_A) + Xc.T @ Xc)
    M_n = V_n @ (inv(Sigma_A) @ A0 + Xc.T @ Yc)
    A_post = np.zeros((3, 3))
    for i in range(3):
        A_post[i, :] = np.random.multivariate_normal(M_n[i, :], Q_post * V_n[i, i])
    return mu_post, A_post, Q_post

# Sample H
def sample_H(yields, betas, lambd):
    a_H, b_H = 2.0, 0.5
    T, N = yields.shape
    L = nelson_siegel_loadings(taus, lambd)
    H_diag = np.zeros(N)
    for i in range(N):
        eps = yields[:, i] - betas @ L[i]
        shape = a_H + T / 2
        scale = b_H + 0.5 * np.sum(eps**2)
        H_diag[i] = stats.invgamma.rvs(a=shape, scale=scale)
    return np.diag(H_diag)

# Sample lambda
def sample_lambda(yields, betas, lambda_curr, H, proposal_std=0.005):
    alpha_lambda, beta_lambda = 5.5, 15
    lambda_prop = abs(lambda_curr + np.random.normal(0, proposal_std))
    L_curr = nelson_siegel_loadings(taus, lambda_curr)
    L_prop = nelson_siegel_loadings(taus, lambda_prop)
    loglik_curr = -0.5 * np.sum((yields - betas @ L_curr.T)**2 / np.diag(H))
    loglik_prop = -0.5 * np.sum((yields - betas @ L_prop.T)**2 / np.diag(H))
    logprior_curr = stats.gamma.logpdf(lambda_curr, alpha_lambda, scale=1 / beta_lambda)
    logprior_prop = stats.gamma.logpdf(lambda_prop, alpha_lambda, scale=1 / beta_lambda)
    log_accept_ratio = (loglik_prop + logprior_prop) - (loglik_curr + logprior_curr)
    return lambda_prop if np.log(np.random.rand()) < log_accept_ratio else lambda_curr

# Initialize MCMC
num_iters = 15000
burn_in = 5000
lambda_samples, A_samples, mu_samples, Q_samples, H_samples = [], [], [], [], []
lambda_curr = 0.06
mu = np.zeros(3)
A = np.eye(3) * 0.95
Q = 0.01 * np.eye(3)
H = 0.01 * np.eye(N)
betas = np.zeros((T, 3))

# Run MCMC
for _ in tqdm(range(num_iters)):
    L = nelson_siegel_loadings(taus, lambda_curr)
    betas = ffbs_stable(yields, L, A, mu, Q, H)
    mu, A, Q = sample_mu_A_Q_bayesian(betas)
    H = sample_H(yields, betas, lambda_curr)
    lambda_curr = sample_lambda(yields, betas, lambda_curr, H)
    lambda_samples.append(lambda_curr)
    A_samples.append(A.copy())
    mu_samples.append(mu.copy())
    Q_samples.append(Q.copy())
    H_samples.append(H.copy())

# Convert to arrays
lambda_samples = np.array(lambda_samples)[burn_in:]
A_samples = np.array(A_samples)[burn_in:]
mu_samples = np.array(mu_samples)[burn_in:]
Q_samples = np.array(Q_samples)[burn_in:]
H_samples = np.array(H_samples)[burn_in:]


# ---- TRACE PLOT ----
plt.figure(figsize=(12, 5))
plt.plot(lambda_samples)
plt.title("Trace Plot of λ (Decay Parameter)")
plt.xlabel("Iteration")
plt.ylabel("λ")
plt.grid(True)
plt.show()

# ---- POSTERIOR HISTOGRAM ----
plt.figure(figsize=(6, 4))
sns.histplot(lambda_samples, kde=True, bins=20)
plt.title("Posterior Distribution of λ")
plt.xlabel("λ")
plt.grid(True)
plt.show()

# ---- AUTOCORRELATION ----
fig, ax = plt.subplots(figsize=(6, 4))
plot_acf(lambda_samples, ax=ax, lags=40)
plt.title("Autocorrelation of λ")
plt.show()

# --- Extract parameter traces ---
a11_samples = [A[0, 0] for A in A_samples]
a22_samples = [A[1, 1] for A in A_samples]
a33_samples = [A[2, 2] for A in A_samples]

mu1_samples = mu_samples[:, 0]  # level
mu2_samples = mu_samples[:, 1]  # slope
mu3_samples = mu_samples[:, 2]  # curvature

# --- Define diagnostic function ---
def plot_diagnostics(samples, label):
    # Trace plot
    plt.figure(figsize=(12, 4))
    plt.plot(samples)
    plt.title(f"Trace Plot of {label}")
    plt.xlabel("Iteration")
    plt.ylabel(label)
    plt.grid(True)
    plt.show()

    # Posterior distribution
    plt.figure(figsize=(6, 4))
    sns.histplot(samples, kde=True, bins=20)
    plt.title(f"Posterior Distribution of {label}")
    plt.grid(True)
    plt.show()

    # Autocorrelation
    fig, ax = plt.subplots(figsize=(6, 4))
    plot_acf(samples, ax=ax, lags=40)
    plt.title(f"Autocorrelation of {label}")
    plt.show()

# --- Run diagnostics for A diagonal ---
plot_diagnostics(a11_samples, "A[0, 0]")
plot_diagnostics(a22_samples, "A[1, 1]")
plot_diagnostics(a33_samples, "A[2, 2]")

# --- Run diagnostics for mu components ---
plot_diagnostics(mu1_samples, "μ1 (level)")
plot_diagnostics(mu2_samples, "μ2 (slope)")
plot_diagnostics(mu3_samples, "μ3 (curvature)")

### Q4
fig, axes = plt.subplots(3, 3, figsize=(15, 12))
fig.suptitle("Posterior Densities of Elements of Autoregressive Matrix A", fontsize=16)

from scipy.stats import gaussian_kde

for i in range(3):
    for j in range(3):
        samples_ij = np.array([A[i, j] for A in A_samples], dtype=np.float64)
        samples_ij = samples_ij[np.isfinite(samples_ij)]
        ax = axes[i, j]
        if len(samples_ij) > 1:
            kde = gaussian_kde(samples_ij)
            x_vals = np.linspace(min(samples_ij), max(samples_ij), 200)
            ax.plot(x_vals, kde(x_vals))
            ax.fill_between(x_vals, kde(x_vals), alpha=0.3)
            ax.set_title(f"A[{i}, {j}]")
        else:
            ax.set_title(f"A[{i}, {j}] - Insufficient Data")
        ax.grid(True)

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()

### Q5

# Use last sampled values for predictive distribution
A_hat = A_samples[-1]
mu_hat = mu_samples[-1]
Q_hat = Q_samples[-1]
lambda_hat = lambda_samples[-1]
H_hat = H_samples[-1]

# Predict one-step-ahead beta_{T+1}
beta_T = betas[-1]
mean_beta_next = mu_hat + A_hat @ (beta_T - mu_hat)
cov_beta_next = Q_hat

# Draw posterior predictive samples
num_draws = 1000
beta_preds = np.random.multivariate_normal(mean_beta_next, cov_beta_next, size=num_draws)

# Generate NS loadings for forecast
L_pred = nelson_siegel_loadings(taus, lambda_hat)
y_pred_samples = beta_preds @ L_pred.T  # shape: (num_draws, N)

# Predictive mean and intervals
y_mean = y_pred_samples.mean(axis=0)
y_lower = np.percentile(y_pred_samples, 2.5, axis=0)
y_upper = np.percentile(y_pred_samples, 97.5, axis=0)

# Plot
plt.figure(figsize=(10, 6))
plt.plot(taus, y_mean, label="Predictive Mean", linewidth=2)
plt.fill_between(taus, y_lower, y_upper, alpha=0.3, label="95% Predictive Interval")
plt.scatter(taus, yields[-1], color="red", label="Last Observed Yield", zorder=5)
plt.title("One-Step-Ahead Predictive Yield Curve")
plt.xlabel("Maturity (Months)")
plt.ylabel("Yield (%)")
plt.grid(True)
plt.legend()
plt.show()


### Q5 P2

# Select maturities of interest (in months)
maturity_labels = [3, 6, 9, 12, 15, 18, 21, 24, 30, 36,
                   48, 60, 72, 84, 96, 108, 120, 180, 240, 360]
maturity_indices = [np.where(taus == m)[0][0] for m in maturity_labels]

# Forecast settings
forecast_horizon = 52  # e.g. 1 year of weekly forecasts
num_draws = 500

# Containers
forecast_curves = np.zeros((num_draws, forecast_horizon, len(maturity_indices)))

# Use final posterior parameters
A_hat = A_samples[-1]
mu_hat = mu_samples[-1]
Q_hat = Q_samples[-1]
lambda_hat = lambda_samples[-1]
H_hat = H_samples[-1]
L_hat = nelson_siegel_loadings(taus, lambda_hat)
beta_0 = betas[-1]

# Simulate future paths
for d in range(num_draws):
    beta_sim = np.zeros((forecast_horizon, 3))
    beta_sim[0] = np.random.multivariate_normal(mu_hat + A_hat @ (beta_0 - mu_hat), Q_hat)
    for t in range(1, forecast_horizon):
        beta_sim[t] = np.random.multivariate_normal(mu_hat + A_hat @ (beta_sim[t-1] - mu_hat), Q_hat)
    y_sim = beta_sim @ L_hat.T
    forecast_curves[d] = y_sim[:, maturity_indices]

# Plot similar to the image (each subplot = 1 maturity)
fig, axes = plt.subplots(5, 4, figsize=(16, 12), sharex=True, sharey=False)
start_date = pd.to_datetime("2018-01-01")
past_time = pd.date_range(start=start_date, periods=T, freq="W")
future_time = pd.date_range(start=past_time[-1] + pd.Timedelta(weeks=1), periods=forecast_horizon, freq="W")

for idx, ax in enumerate(axes.flatten()):
    if idx >= len(maturity_indices):
        ax.axis("off")
        continue
    m_idx = maturity_indices[idx]
    m_label = maturity_labels[idx]
    
    # Plot historical
    hist = yields[:, m_idx]
    ax.plot(past_time, hist, color="blue", linewidth=1)

    # Forecast paths
    for d in range(num_draws):
        ax.plot(future_time, forecast_curves[d, :, idx], color="gray", alpha=0.02)

    # Zoom in: use percentiles instead of min/max
    lower = np.percentile(forecast_curves[:, :, idx], 1)
    upper = np.percentile(forecast_curves[:, :, idx], 99)
    y_min = min(hist.min(), lower)
    y_max = max(hist.max(), upper)
    margin = 0.2 * (y_max - y_min)
    ax.set_ylim(y_min - margin, y_max + margin)

    ax.set_title(f"Curva de {m_label} meses")
    ax.set_xlim(start_date, future_time[-1])

fig.suptitle("Previsões semanais para os vértices entre 3 e 360 meses", fontsize=16)
plt.tight_layout(rect=[0, 0.03, 1, 0.97])
plt.show()

### A Corrigido

# Filter A_samples to retain only those with all eigenvalues < 1 in modulus
stable_indices = [i for i, A in enumerate(A_samples) if np.all(np.abs(eigvals(A)) < 1.0)]

# Apply to all parameter chains and betas if needed
A_samples_stable = [A_samples[i] for i in stable_indices]
mu_samples_stable = mu_samples[stable_indices]
Q_samples_stable = Q_samples[stable_indices]
lambda_samples_stable = lambda_samples[stable_indices]
H_samples_stable = [H_samples[i] for i in stable_indices]


# Predictive yield curve using stable draws
# Use mean of last stable draws for parameters
A_hat = A_samples_stable[-1]
mu_hat = mu_samples_stable[-1]
Q_hat = Q_samples_stable[-1]
lambda_hat = lambda_samples_stable[-1]
H_hat = H_samples_stable[-1]
beta_T = betas[-1]

# Predict one-step-ahead beta
mean_beta_next = mu_hat + A_hat @ (beta_T - mu_hat)
cov_beta_next = Q_hat

# Draw posterior predictive samples
num_pred_draws = len(A_samples_stable)
beta_preds = np.random.multivariate_normal(mean_beta_next, cov_beta_next, size=num_pred_draws)

# Yield predictions
L_pred = nelson_siegel_loadings(taus, lambda_hat)
y_pred_samples = beta_preds @ L_pred.T
y_mean = y_pred_samples.mean(axis=0)
y_lower = np.percentile(y_pred_samples, 2.5, axis=0)
y_upper = np.percentile(y_pred_samples, 97.5, axis=0)

# Plot
plt.figure(figsize=(10, 6))
plt.plot(taus, y_mean, label="Predictive Mean", color="blue")
plt.fill_between(taus, y_lower, y_upper, alpha=0.3, label="95% Predictive Interval")
plt.scatter(taus, yields[-1], color="red", label="Last Observed Yield", zorder=5)
plt.title("One-Step-Ahead Predictive Yield Curve (Stable Draws Only)")
plt.xlabel("Maturity (Months)")
plt.ylabel("Yield (%)")
plt.grid(True)
plt.legend()
plt.show()

# Use stable samples for forecasting
num_draws_stable = len(A_samples_stable)
forecast_curves_stable = np.zeros((num_draws_stable, forecast_horizon, len(maturity_indices)))

# Last known state
beta_0 = betas[-1]
L_hat = nelson_siegel_loadings(taus, np.mean(lambda_samples_stable))

# Simulate from stable draws
for d in range(num_draws_stable):
    A_hat = A_samples_stable[d]
    mu_hat = mu_samples_stable[d]
    Q_hat = Q_samples_stable[d]
    beta_sim = np.zeros((forecast_horizon, 3))
    beta_sim[0] = np.random.multivariate_normal(mu_hat + A_hat @ (beta_0 - mu_hat), Q_hat)
    for t in range(1, forecast_horizon):
        beta_sim[t] = np.random.multivariate_normal(mu_hat + A_hat @ (beta_sim[t-1] - mu_hat), Q_hat)
    y_sim = beta_sim @ L_hat.T
    forecast_curves_stable[d] = y_sim[:, maturity_indices]

# Plot forecast panel with stable draws only
fig, axes = plt.subplots(5, 4, figsize=(16, 12), sharex=True, sharey=False)
start_date = pd.to_datetime("2018-01-01")
past_time = pd.date_range(start=start_date, periods=T, freq="W")
future_time = pd.date_range(start=past_time[-1] + pd.Timedelta(weeks=1), periods=forecast_horizon, freq="W")

for idx, ax in enumerate(axes.flatten()):
    if idx >= len(maturity_indices):
        ax.axis("off")
        continue
    m_idx = maturity_indices[idx]
    m_label = maturity_labels[idx]

    # Plot historical
    hist = yields[:, m_idx]
    ax.plot(past_time, hist, color="blue", linewidth=1)

    # Forecast paths
    for d in range(num_draws_stable):
        ax.plot(future_time, forecast_curves_stable[d, :, idx], color="gray", alpha=0.02)

    # Add mean forecast line
    mean_forecast = forecast_curves_stable[:, :, idx].mean(axis=0)
    ax.plot(future_time, mean_forecast, color="black", linewidth=1.5, label="Média preditiva")

    # Dynamic y-limits
    lower = np.percentile(forecast_curves_stable[:, :, idx], 1)
    upper = np.percentile(forecast_curves_stable[:, :, idx], 99)
    y_min = min(hist.min(), lower)
    y_max = max(hist.max(), upper)
    margin = 0.2 * (y_max - y_min)
    ax.set_ylim(y_min - margin, y_max + margin)

    ax.set_title(f"Curva de {m_label} meses")
    ax.set_xlim(start_date, future_time[-1])

fig.suptitle("Previsões semanais para os vértices entre 3 e 360 meses (com média preditiva) Stable Draws", fontsize=16)
plt.tight_layout(rect=[0, 0.03, 1, 0.97])
plt.show()