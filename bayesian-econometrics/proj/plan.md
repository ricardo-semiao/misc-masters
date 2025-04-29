# The MS-VAR Model

The authors defend the use of a Markov Switching VAR model, as its non-linear nature allows for capturing dynamic properties (time-varying cycles, breaks/jumps, etc.). I'll briefly describe it below.

$$
\begin{array}{l}
    X_t = \begin{cases}
        \alpha_1 + \beta_{11}X_{t-1} + \dots + \beta_{p1}X_{t-p} + A_1v_t & \text{if} ~~ S_t = 1\\
        ~~~~~~~~~~~~~~~~~~~~~\vdots &\\
        \alpha_m + \beta_{1m}X_{t-1} + \dots + \beta_{pm}X_{t-p} + A_mv_t & \text{if} ~~ S_t = m\\
    \end{cases}\\
    V_t \sim N(0, I_k)
\end{array}
$${#eq-msvar}

Where:

- $X_t$ are the $K$ endogenous variables.
- $\alpha_i, \beta_{1i}, \dots, \beta_{pi}$, for all the $m$ regimes $i$, are the VAR($p$) coefficients.
- $A_iv_t$ are the residuals.
- $S_t$ is an unobserved regime variable.

Note that the variance-covariance matrix of the residuals is regime dependent.

$$
\Sigma_{i} = E\Big(A_{i}V_{\nu}V_{\nu}^{'}A_{i}^{'}\Big)=A_{i}E\left(V_{\nu}V_{\nu}^{'}\right)A_{i}^{'}=A_{i}I_{K}\,A_{i}^{'}=A_{i}A_{i}^{'}
$${#eq-cov-matrix}

$S_t$ is assumed to be independent of past $X$'s, and, conditional on $S_{t-1}$, follow a hidden Markov process:

$$
Pr(S_t = j | S_{t-1} = i) = p_{ij},~~ \forall_t,~ \forall_{i,j \in \{1, \dots, m\}}
$$

The transition probabilities are grouped in the transition probability matrix $P$:

$$
P = \begin{bmatrix}
    {{P_{11}}}&{{P_{12}}}&{{\cdot\cdot\cdot}}&{{P_{1m}}}\\
    {{p_{21}}}&{{p_{22}}}&{{\cdot\cdot}}&{{P_{2m}}}\\
    {{\vdots}}&{{\vdots}}&{{\ddots}}&{{\vdots}}\\
    {{P_{m1}}}&{{P_{m2}}}&{{\cdot\cdot}}&{{P_{m m}}}
\end{bmatrix}
$${#eq-transition-matrix}

Equations -@eq-msvar, -@eq-cov-matrix, and -@eq-transition-matrix are the core model. All parameters are allowed to switch with the regime. Regime changes are treated as random events modelled by the Markov process.

In the paper, $K = 3$ (see data section), $p = 2$ (see model selection section), $m = 2$ (high and low uncertainty), and $T = 312$ time periods. Then, we have the following parameters:

- $\alpha$, the $m \times 1$ vector of intercepts
- $\beta$, the $m \times p$ matrix of coefficients.
- All the $m$ $K \times K$ variance-covariance matrices $\Sigma = \{\Sigma_i: i = 1, \dots, m\}$.
- The $m \times m$ transition probability matrix $P$.

In total $\theta \coloneqq (\alpha, \beta, \Sigma, P)$ has $m \times (1 + p + K^2 + m) = 18$ parameters.


## Original Paper's Estimation Description

Original paper "jcbtp-2020-0030.pdf" section "3.2 Estimation":

> We follow Balcilar et al. (2017) to implement the bayesian MCMC estimation approach and adopt the following steps:

> a. Draw the parameters given the regimes
> b. Draw the regimes given transitional probabilities and parameters of the model.
> c. Draw the transitional probabilities given regimes. Here we do not include model parameters like excluding transition > probabilities in the first step.
> d. Draw Σi, given regimes, transitional probabilities and parameters using a hierarchical prior.

> In the second step above, we put a threshold level for a draw to be accepted that is at least 5 per cent of the observations must fall in the regimes associated with the particular draw. In step (c), we use Dirichlet distribution to draw unconditional probabilities P, given the regimes. We set the priors for the Dirichlet distribution as 80 and 20 per cent probability respectively of staying in the same regime and switching to the other regime. We perform the MCMC integration with 60,000 posterior draws with 30,000 burn-in draws.
