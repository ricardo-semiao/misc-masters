---
title: "Computational Methods in Economics - Final Project"
author: "Ricardo Semião e Castro"
date: "2025-04-10"
execute:
  eval: false
  echo: true
format: 
    revealjs:
        embed-resources: true
        fontsize: 32px
        transition: fade
        slide-number: true
---


# Introduction

## Objective

- Study _2-step hybrid optimization methods_, under a generalist framing.
  - Two stages: firstly deal with complex aspects of the problem, and then solve the remaining, simpler, problem with more efficient methods.
- Rewrite several types of problems into a common, hybrid-aligned, format - including a semi-novel one.
  - Problems with "endogenous domains".
- Create a generalist code implementation in R, and test the method's performance.


## Plan

1. Cite examples of common problems tackled by hybrid methods and define them formally.
2. Rewrite them all in the same language, showing that the special class can be included in the same framework.
3. Describe the method's design in our framing.
4. Create a generalist implementation in R.
5. Test the method, with a special focus on "endogenous domains" problems. Present results and performance considerations, followed by concluding remarks.



# Considered Problems

## Considered Problems

We will consider three types of 'bad behaviors':

- 'Badly-behaved' variables, be it non real-valued ones (integer or categorical), or real-valued variables that imply a hard-to-solve problem in an otherwise simpler one.
- 'Badly-behaved' constraints, be it with real-valued functions, or complex functions in an otherwise simpler problem.
- Endogenous domains mentioned above.

Example: A central planner choosing lump-sum taxes $\tau$ and government good amount $x$ to maximize some social welfare function.

$$
\begin{array}{l}
    \max_{\tau} u(\tau) = U_G(\tau) + U_P(\tau)\\
    u: \mathbb{R}^+ \to \mathbb{R}
\end{array}
$$

## Discrete Variables

Consider the discrete nature of money, with the smallest unit being $0.01$:

$$
\begin{array}{l}
  \max_{\tau} u(\tau) = U_G(\tau) + U_P(\tau)\\
  u: [0.01, 0.02, \dots] \to \mathbb{R}
\end{array}
$$


## Categorical Variables

Suppose the government can choose different taxes $\tau_s$ for each group $s \in \{A, B\}$ of the population $i \in \{1, 2, \dots, N\}$. We can pass the variable $S$ specifying who is in which group:

$$
\begin{array}{c}
  S \in \{A, B\}^N\\
  \tau_i(S_i) = I\{S_i = A\}\tau_A + I\{S_i = B\}\tau_B
\end{array}
$$

Then, our problem is now mixed with a categorical variable:

$$
\begin{array}{l}
  \max_{\tau, S} u(\tau, S) = U_G(\tau, S) + \sum_{i = 1}^N U_P^i(\tau_i(S_i))\\
  u: (\mathbb{R}^+)^2 \times \{A, B\}^N \to \mathbb{R}
\end{array}
$$


## Constraints and Specific Variables

Furthermore, we can add constraints to the problem, which can even involve these non-real-valued variables, being mixed-variable functions themselves:

- A real or integer budget constraint of the form $x \cdot p \leq f(\tau)$.
- A categorical constraint on the sizes of the groups $\sum_{i = 1}^N I\{S_i = A\} = 0.5N$.

We can also think about specific variables that affect the objective function and/or constraints in especially complex ways.


## Endogenous Domain

What if the central planner, before choosing $\tau$, must commit to it being in some interval $[\tau_{lim}, \tau_{lim} + c]$, $c \in \mathbb{R}$?

$$
\begin{array}{l}
  \max_{\tau, \tau_{lim}} u(\tau)\\
  u: [\tau_{lim}, \tau_{lim} + c] \to \mathbb{R}
\end{array}
$$

Or, maybe, the number of groups can be chosen, such that $s \in \{A, B\}$ or $\{A,B,C\}$, etc.

$$
\begin{array}{l}
  \max_{\tau, S, \mathcal{S}} u(\tau, S) = U_G(\tau, S) + \sum_{i = 1}^N U_P^i(\tau_i(S_i))\\
  u: (\mathbb{R}^+)^2 \times \mathcal{S}^N \to \mathbb{R}
\end{array}
$$

We might have trade-offs (constraints) for these choices.


## Endogenous Domain

Consider the researcher's problem: they have data on $\tau$ and $y = u(\tau; \theta)$ and want to estimate some parameter $\theta$ by minimizing some loss function $L(\theta; y - u(\tau; \theta))$.

They don't know the scale of the abstract parameter $\theta$ but must choose a domain for the computational method of their choosing. Then:

$$
\begin{array}{l}
  \min_{\theta, \Theta} L(\theta; y - u(\tau; \theta))\\
  L: \Theta \to \mathbb{R}
\end{array}
$$


## Endogenous Domain

While this formulation could be interesting, it is not fundamentally different from using a general domain and creating a new constraint $x \in \{\tau_{lim}, \tau_{lim} + c\}$.

The last example didn't have a rule, but I'll show that we can rewrite it too in the same way.



# Theoretical Framework

## Separating Variables and Constraints

I can always separate, from the full $x$, the variables $\tilde{x}$ to be worked only on the first step.

If some constraints depend only on $\tilde{x}$, we can separate them into $\tilde{g}(\tilde{x})$.


## Rewriting Domain Restrictions

First, the equivalence below shows we can write domain restrictions as constraints:

$$
\begin{array}{c}
x \in X ~~\Leftrightarrow~~ \tilde{g}(x) \geq 0,~ \tilde{g}: X = \{x: \tilde{g}(x) \geq 0\}
\end{array}
$$

We can transform $X = \mathbb{N} \to \mathbb{R}$ by adding $\tilde{g}(x) = -|x_2 - floor(x_2)|$.

We can encode categorical domains with numeric variables, but need to keep that in mind during the optimization step.


## Rewriting Endogenous Domains

We can map the domain options $\mathcal{X}$ into a set of indexes $\tilde{X}$. Then, we can rewrite our problem as choosing the index:

$$
\begin{array}{l}
  \max_{x, \tilde{x}} f(x) ~~s.t.~~ g(x) \geq 0\\
  f: X_{\tilde{x}} \to \mathbb{R}^n,~ g: X_{\tilde{x}} \to \mathbb{R}^{m},~ \tilde{x} \in \tilde{X}
\end{array}
$$

Based on the last slide, we can change the domain options $\mathcal{X}$ into restriction options $G_{\mathcal{X}}$:

$$
G_{\mathcal{X}},~~ G_{\mathcal{X}} = \{g_{\tilde{x}}: X = \{x: g_{\tilde{x}}(x) \geq 0\},~ X \in \mathcal{X}\}
$$

Then, we can trade the domain choosing for the constraint:

$$
\tilde{g}(x, \tilde{x}) = \sum_{i \in \tilde{X}} I\{i = \tilde{x}\}g_{\tilde{x}}(x)
$$

Where $I\{.\}$ is the indicator function and the 'size' of $\mathcal{X}$ might require a $\int$.


## The Reframed Problem

- We separate our variables into $x$ and $\tilde{x}$, and separated $\tilde{g}$.
- Applied the transformations described to get a domain $X \subseteq \mathbb{R}^k$.
- Added restrictions on $g$.

$$
\begin{array}{c}
    \max_{x, \tilde{x}} f(x, \tilde{x}) ~~s.t.~~ g(x, \tilde{x}) \geq 0,~ \tilde{g}(\tilde{x}) \geq 0\\
    f: X \to \mathbb{R}^n,~ g: X \times \tilde{X} \to \mathbb{R}^{m},~ \tilde{g}: \tilde{X} \to \mathbb{R}^{\tilde{m}}
\end{array}
$$



# Method Design

## First Step: Create Initial Sample of $\tilde{x}$

The first step is to create an initial population of the "bad" variables $\tilde{x}$, $S_0 = (\tilde{x}_s)_{s = 1}^N$. If there are any restrictions $\tilde{g}$, they can be dealt with in this step. We have some possible methods:

- **Random sampling:**
  - Sample from a mass/density function $p: \tilde{X} \to [0,1]$.
    - Constant function, or an educated guess a-la importance sampling.
  - Only the ones that satisfy the constraints $\tilde{g}$ are kept.
- **Iterative sampling:**
  - Sample one variable in $\tilde{x}$ at random.
  - Update the 'feasible domain' of the rest.
  - Repeat until all variables are sampled.


## Second Step: Solve the Reduced Problem

Now, the user selects any method of choice to solve the reduced problem:

$$
\begin{array}{c}
    \max_{x} f(x, \tilde{x}) ~~s.t.~~ g(x, \tilde{x}) \geq 0\\
    f: X \to \mathbb{R}^n,~ g: X \to \mathbb{R}^m
\end{array}
$$

For each $\tilde{x} \in S$, the problem is solved into $x^*$, and an ordered set of the results - and some meta information $M_s$ - is stored, yielding:

$$
O_S = (\tilde{x}_s,~ x^*_s,~ f(x^*_s, \tilde{x}_s),~ M_s)_{s = 1}^N
$$

The user defines the desired method to solve the problem. One can even choose more than one method, randomly selecting one of them for each $\tilde{x}$.


## Third Step: Update the Sample

This is the more complicated step, we want to define some rule $S_{t+1} = T(S_t, O_{S_t})$.

- Each type of variable has different needs.
- There are many operators in the literature.
  - Genetic algorithms use operations based on selecting the best performing samples, combining them via crossover, and varying them via mutations.
- Easy way to customize the method to your needs.
  - I intend to create a custom one for the 'researcher's problem'.

The stopping criteria normally is "the best solution so far has not changed in the last $n$ iterations".



# Coding Implementation

## Structure - Arguments

First, let's talk about the setup. The main function will have arguments for:

- The objective function, and constraints $g$ and $\tilde{g}$, irrelevant by default.
- The operators for each of the three steps explained.
- The (most general) domain of the variables $x$ and $\tilde{x}$.
- The number of samples.
- The 'flow' helpers, which are used to define when to stop, what to track/log, and what to return at the end.

```r
optim_hybrid <- function(
  obj_fun,
  x_dom, xtil_dom,
  g_fun = NULL, gtil_fun = NULL,
  initializer, optimizer, updater,
  n_samples,
  stopper = flow_stopper(), tracker = flow_tracker(), saver = flow_saver()
) {
  #...setup
```

They will be implemented using constructor functions.


## Structure - Setup

The first part is the setup of the function:

```r
  #...arguments
  # Test arguments
  test_classes()
  test_funs()
  g <- g %||% \(x, xtil) 0
  gtil <- gtil %||% \(xtil) 0

  # Initialize containers
  xtil <- vector("list", length(stopper$max_iter))
  results <- vector("list", length(stopper$max_iter))
  metrics <- list(val = c(x = NA, f = NA), n = c(x = 0, f = 0))

  # First iteration with
  t_init_0 <- Sys.time()
  t <- 1
  xtil[[t]] <- try_abort(initializer, list(xtil_dom, gtil_fun))
  t_init_1 <- Sys.time()
  #...main loop
```


## Helpers - Testing

Testing if the arguments were created with the correct constructors, which assign specific classes for them.

```r
test_classes <- function(env = caller_env()) {
  iwalk(
    list(
      x_dom = "hyop_domain", xtil_dom = "hyop_domain",
      op_init = "hyop_init", op_optim = "hyop_optim", op_trans = "hyop_trans",
      stop_crit = "hyop_stopper", tracker = "hyop_tracker", saver = "hyop_saver"
    ),
    function(c, arg_name){
      if (!inherits_only(env[[arg_name]], c)) {
        abort(
          "`{arg_name}` must be of class '{c}'. See the helper function with same name.",
          call = env
        )
      }
    }
  )
}
```


## Helpers - Testing

Testing if the functions have the correct number of arguments.

```r
test_funs <- function(env = caller_env()) {
  iwalk(
    list(obj_fun = 2, g_fun = 2, gtil_fun = 1),
    function(n_args, arg_name){
      if (length(formals(obj_fun)) != n_args) {
        abort(
          "`{arg_name}` must have exactly {n_args} arguments, relating \\
          (in order) to `x`{`if`(n_args==2, 'and `xtil`', )}.",
          call = env
        )
      }
    }
  )
}
```


## Helpers - Error Handling

The user-provided functions are wrapped in a `tryCatch`, to warn if any errors came from them.

```r
try_abort <- function(fun, args, fun_name, env = caller_env()) {
  fun_name <- as_name(ensym(fun))

  tryCatch(do.call(fun, args),
    error = function(e) {
      abort("Error in iteration {env$t}, in {fun_name}: {e$message}", call = env)
    },
    warning = function(x) {
      abort("Warning in iteration {env$t}, in {fun_name}: {w$message}", call = env)
    },
    message = function(x) {
      abort("Message in iteration {env$t}, in {fun_name}: {m$message}", call = env)
    }
  )
}
```


## Structure - Main Loop

1. Optimizes the reduced problems, storing the results via `saver$results()`.
2. Logs the results via `tracker()`, and checks the stopping criteria via `stopper`.
3. Updates the sample via `op_trans`.

```r
  #...setup
  t_loop_0 <- Sys.time()
  for (t in seq(2, stopper$max_iter, 1)) {
    # Optimizing the sample
    results[[t]] <- saver$results(try_abort(optimizer,
      list(xtil[[t]], x_dom, g_fun, t)
    ))

    # Logging the results
    tracker(results[[t]]$x, results[[t]]$f, t, stopper$get_metrics)

    # Checking the stopping criteria
    metrics <- stopper$get_metrics(results[[t]], metrics)
    if (stopper$check(metrics)) break

    # Updating the sample
    xtil[[t + 1]] <- try_abort(updater,
      list(x_dom, g_fun, xtil_dom, gtil_fun, results[[t]], n_samples)
    )
  }
  t_loop_1 <- Sys.time()
  #...results
```


## Results

Finally, results are returned:

```r
  #...main loop
  list(
    x_star = list(results[[t]]$x, results[[t]]$xtil),
    f_star = results[[t]]$f,
    duration = list(
      iters = t,
      time_init = t_init_1 - t_init_0,
      time_loop = t_loop_1 - t_loop_0,
      time_loop_avg = (t_loop_1 - t_loop_0) / t,
      time_total = t_loop_1 - t_init_0
    ),
    diagnostics = saver$diag(results, stopper$get_metrics)
  )
}
```


## Helpers - Stopper Constructor

The stopper, tracker, and saver all have their constructors, for example:

```r
hyop_stopper <- function(
  max_iter = 1000, type = "xft", both = TRUE,
  x_metric = median, x_iter = 10, x_tol = 0.1,
  f_metric = min, f_iter = 10, f_tol = 0
) {
  get_metrics <- function(results_t, metrics) {
    metrics_t <- c(x = x_metric(results_t$x), y = f_metric(results_t$f))

    which_better <- metrics_t >= metrics$val * (1 + c(x_tol, f_tol))
    metrics$val <- ifelse(which_better, metrics_t, metrics$val)
    metrics$n <- ifelse(which_better, 1, metrics$n + 1)

    metrics
  }

  check <- function(metrics) {
    conditions <- (metrics$iter >= c(x_iter, f_iter)) & (c("x", "f") %in% type)
    do.call(`if`(both, all, any), conditions)
  }

  list(max_iter = max_iter, get_metrics = get_metrics, check = check)
}
```

Which returns an object in the precise way that the sampling operators need.

## Helpers - Domains Constructor

```r
hyop_domain(
  x1 = list(double, 0, 5),
  x2 = list(integer, 1, 10),
  x3 = list(factor, c("M", "F")),
  x4 = list(factor, letters, ordered = TRUE)
)
```

Which returns an object in the precise way that the sampling operators need.


## Package Structure

I am creating the method in a package format, with documentation, etc.

![](../personal/doc.png)


## Package Structure

It is built with `devtools` and `pkgdown`. Its structure is as follows:

```
hyoptr/
├── R/
│   ├── flow.R
│   ├── hyoptr-package.R
│   ├── operators.R
│   ├── optim_hybrid.R
│   └── tests.R
├── man/
│   └── documentation '.Rd' for each function in R/
├── docs/
│   └── pkgdown html site-documentation files
├── .gitignore and .Rbuildignore
├── DESCRIPTION and NAMESPACE
├── dev.R
├── hyoptr.Rproj
└── README.Rmd and README.MD
```


# Performance Check

## Performance Check

My intention is to run the method for different problems and with different operators, to see when it performs well and when it doesn't. Special focus on the endogenous domain problem will be given.
