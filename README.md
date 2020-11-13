# Finite-sample analysis of M-estimators  using self-concordance

Matlab implementation of numerical experiments from the paper

[Dmitrii M. Ostrovskii, Francis Bach. Finite-sample analysis of M-estimators using Self-Concordance](https://arxiv.org/abs/1810.06838)

To run the experiments, clone or download the repository and launch the following MATLAB commands: 
```
run_exp_gauss
run_exp_hazan
```
The data for the curves will appear in ``data/<...>``, where ``<...>`` corresponds to the experiment: ``Gauss-logistic`` and ``Hazan-always-1``.
Plots will appear in similar subfolders in ``plots/<...>``. 

The experiments that reproduce the curves reported in the paper take a few days to run. To obtain (less accurate) results faster,
change the number of Monte-Carlo trials: parameter ``T`` in ``run_exp_gauss.m`` and ``run_exp_hazan.m``. 

##

One may also explore additional scenarios by changing ``xKey`` and ``yKey`` parameters, corresponding to the scenarios for design and label: 
``xKey``: ``'Gauss'``, ``'Hazan'`` or ``'Rademacher'``;   
``yKey``: ``'always-1'``, ``'0-1'``, ``'logistic'``, ``'ill-spec'`` or ``'probit'``.  
We do not report the entirety of these results in the paper due to space limitations.  

Here, ``Rademacher`` stands for the design with i.i.d. fair Bernoulli entries. 
``yKey`` specifies the conditional distribution of <img src="https://render.githubusercontent.com/render/math?math=Y\in\{\pm 1\}"> 
given <img src="https://render.githubusercontent.com/render/math?math=\eta=X^\top\theta_*">:  
``'0-1'``: <img src="https://render.githubusercontent.com/render/math?math=Y=\sign(\eta)">;  
``'logistic'``: <img src="https://render.githubusercontent.com/render/math?math=\mathbb{P}[Y=1] \sim \exp(\tfrac{1}{2}\eta)">;  
``'ill-spec'``: <img src="https://render.githubusercontent.com/render/math?math=\mathbb{P}[Y=1] \sim \exp(\tfrac{1}{2}\eta\cos(\eta))">;  
``'probit'``: <img src="https://render.githubusercontent.com/render/math?math=\mathbb{P}[Y=1]=1-\phi(\eta)">, where 
<img src="https://render.githubusercontent.com/render/math?math=\phi"> is the standard Gaussian c.d.f.  
