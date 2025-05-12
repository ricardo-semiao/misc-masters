# Tasks From EESP-FGV's Masters in Economics

Welcome! This is the repository for the tasks I've done during my Masters in Economics at EESP-FGV. Each folder belongs to a different class, but have a common structure:

- Each problem set/task has its own folder.
- _psi_ stands for the _i_'th problem set, _rp_ for research project, _rr_ for referee report, amongst others.
- Problem sets normally contain similar files:
    - A _x\_instructions.pdf_ file, with the questions of the P.S.
    - A _x\_main.R_ and _x\_text.tex_ files, to generate the results and the final report, _x.pdf_.
    - Folders such as  _data/_, _figures/_ and _tables/_ (or _output/_), _code/_.
    <!-- - A _latex\_build_ folder, with auxiliary files for the .tex file compilation. -->

Across the time my folder structure convention changed slightly, and I started using more Quarto instead of directly LaTeX, for the simpler documents that the classes required.

There is a [dev.ps1](dev.ps1) PowerShell script, that is used to build this repo.


## Contents

Below, I talk about each of the classes' tasks. Not all of the tasks have the quality level I'd like, and in the future I intent to do the upgrades I didn't had time to during the classes' duration.


### [Econometrics II](econometrics2) (2024T2)

An time series econometrics class. The problems were varied, with math derivations, empirical analysis, and simulations. The themes were:

- Stationarity analysis.
- ARIMA, VAR, VECM models.
- GMM.
- Dynamic Panel Models.


### [Statistical Learning](statistical-learning) (2025T1)

A class focused on machine learning techniques and their applications in economics. The only task was an presentation, referee report, and replication of a paper.

I choose "A Hybrid Learning Approach to Detecting Regime Switches in Financial Markets" [(Akioyamen et. al. 2021)](https://arxiv.org/pdf/2108.05801). About it:

> The authors utilize a PCA-based dimensionality reduction approach followed by clustering to detect regimes in the US economy. Then, they create classification models to predict these regimes, arguing that this second step yields a method agnostic on how the regimes were defined in the first step.

> Then, they interpret the regimes and discuss portfolio strategies that would benefit from the regime identification. Using the classifiers, they backtest the strategies to test-drive their methodology.

In the [referee report](statistical-learning\texts\referee.pdf), I argue, in general,that the paper does not pose itself to explore all the complex modeling decisions. In the [replication](statistical-learning\texts\paper.pdf), I try to improve the methodology accordingly. I'm very happy with the code quality and generality.


### [Computational Methods in Economics](comp-econ) (2025T1)

A class on computational techniques for solving economic problems. For this class, I started learning Julia.

- Problem set 3 was about numeric integration.
- For the project I choose to create a framework for implementing population-based hybrid-optimization algorithms. The project went well, and I continued it as the [phyopt R package](https://ricardo-semiao.github.io/phyopt/), which I'm am currently developing.


### [Bayesian Econometrics](bayesian-econometrics) (2025T1)

A class on Bayesian methods applied to econometrics.

- The problem sets involved a Bayesian approach to estimate the Nelson Siegel yield curve factor model, its static and dynamic versions. Both required a theoretical first step of prior and algorithm derivation, then code implementation, and finally results analysis.
- For the project I chose to replicate the paper "Uncertainty and Effectiveness of Monetary Policy: A Bayesian Markov Switching-VAR Analysis" [(Nain and Bandi 2020)](https://www.econstor.eu/bitstream/10419/298986/1/1737992825.pdf), which used a Markov Switching VAR model. The authors lacked a clear algorithm derivation, and I tried to fill this gap.


### [Forecasting](forecasting) (2024T3)

Also an time series econometrics task, but focused on forecasting. Here i've used other techniques such as:

- Recursive OLS.
- Model/forecasts evaluation and combination.
- Model diagnostics.
- High dimensionality models, Bayesian VARs.


### [Quantitative Methods in Macroeconomics](quant-macro) (2024T3)

A class on numeric methods to solve macroeconomic models. The tasks were about:

- Basics of numeric methods.
- Methods such as Bisection, Newton-Rapson, Secant, etc.
- Solving dynamic programming problems and Value Function Iteration.
- Macro specific problems, such as solving a RBC model.


### [Econometrics I](econometrics1) (2024T1)

A introductory class on econometrics. The task is described at [instructions.pdf](econometrics1/instructions.pdf), but basically entails the replication of works in the literature of “quantity-quality trade-off”, a la Becker and Lewis (1973) and Becker and Tomes (1976). The finished report is [text.pdf](econometrics1/text.pdf).

The data comes from IPUMS International, the Puerto Rico 2010's census, and is at [data/](econometrics1/data/). The main script is [main.R](econometrics1/main.R), and the report is built with [text.tex](econometrics1/text.tex).


### [Microeconometrics I](microeconometrics1) (2024T3)

A class focused on experiments and causal inference. Again, very varied, mixing theoretical and empirical problems. The tasks were about:

- Identification.
- Experiments attrition, balance, and diagnostics.


### [Heterogeneous Firms in Macroeconomics](heterogeneous-macro) (2024T4)

A class focused on the seminal macroeconomic models with eterogeneity on the firm size, both in size and productivity.

The only task here is an extended research project on a more universal model for studying the effects of development banks, drawing from some of the papers from this, and from a monetary policy class.


### [Monetary Policy Models](monetary-policy) (2024T4)

A class on the basics of monetary policy. The tasks here include mostly the replication of papers, using octave/matlab with dynare.

In one of the tasks, me and my group recreated one of the Brazil's central bank models, but its pending some organization to upload here.
