% Modelo RBC Básico

close all;


%----------------------------------------------------------------
% Defining the variables and parameters of the model
%----------------------------------------------------------------
var y c k i h r z;                                                                       % vari�veis end�genas
varexo e;                                                                                % vari�veis ex�genas
parameters beta psi delta theta rho;                                                     % par�metros


%----------------------------------------------------------------
% Defining the calibration
%----------------------------------------------------------------
theta   = 0.5;                                                                          % capital-share
beta    = 0.99;                                                                          % taxa de desconto temporal
delta   = 0.025;                                                                         % deprecia��o
psi     = 1.72;                                                                          % par�metro de utilidade do lazer
rho     = 0.95;                                                                          % AR(1) da produtividade
sigma   = (0.000010299)^(1/2);                                                           % desvio-padr�o do choque de produtividade


%----------------------------------------------------------------
% Defining the model
%----------------------------------------------------------------
model;
  (1/c) = beta*(1/c(+1))*(1+theta*(k^(theta-1))*(exp(z(+1))*h(+1))^(1-theta)-delta);     % escolha intertemporal do consumo
  psi*c/(1-h) = (1-theta)*(k(-1)^theta)*(exp(z)^(1-theta))*(h^(-theta));                 % escolha renda-lazer
  c+i = y;                                                                               % restri��o or�ament�ria
  y = (k(-1)^theta)*(exp(z)*h)^(1-theta);                                                % fun��o de produ��o
  i = k-(1-delta)*k(-1);                                                                 % equa��o de movimento do capital
  r = theta*y/k;                                                                         % taxa de juros
  z = rho*z(-1)+e;                                                                       % processo estoc�stico da produtividade
end;


%----------------------------------------------------------------
% Defining the steady state
%----------------------------------------------------------------
initval;
  y = 1.2353;
  k = 12.6695;
  c = 0.9186;
  h = 0.33;
  i = 0.316738;
  z = 0;
  e = 0;
  r = 0.0351;
end;


%-------------------------------------------------------------------------------
% Defining the shocks
%-------------------------------------------------------------------------------
shocks;
  var e = sigma^2;
end;


%-------------------------------------------------------------------------------
% Calculating the steady states and checking
%-------------------------------------------------------------------------------
steady;
check;


%-------------------------------------------------------------------------------
% Simulating IRFs
%-------------------------------------------------------------------------------
stoch_simul(hp_filter = 1600, order = 1, nodisplay) y c i;
