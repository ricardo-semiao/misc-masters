// // Modified version of Michel Juillard's code from Dynare Summer School 2021
// An and Schorfheide model
// see An Schorfheide (2006) and Herbst Schorfheide (2016)
// and corrections https://cpb-us-w2.wpmucdn.com/web.sas.upenn.edu/dist/e/242/files/2017/05/corrections_v1-11vpcen.pdf
// Stationary nonlinear version, variables in relative gap to steady state
// Steady state is zero for all variables
// Calibration: An and Schorfheide (2006), Table 3 and page 38.
// Warning: by simplicity we use the same variable names as in as1.mod but the meaning is different

close all;


%-------------------------------------------------------------------------------
% Defining the variables and parameters of the model
%-------------------------------------------------------------------------------
var c y pi R z g;
varexo eg ez eR;
parameters beta tau gamma phi nu pi_star r rho_R rho_z rho_g psi_1 psi_2 g_star;


%-------------------------------------------------------------------------------
% Defining the calibration
%-------------------------------------------------------------------------------
tau = 2.0;
nu = 0.1;
phi = 53.68;
rho_R = 0.6;
rho_z = 0.75;
rho_g = 0.9;
psi_1 = 1.5;
psi_2 = 0.25;
r = 1.0025;
pi_star= 1.008;
gamma = 1.0055;
beta = gamma/r;
g_star = 1/0.85;


%-------------------------------------------------------------------------------
% Defining the model
%-------------------------------------------------------------------------------
model;
  1 = exp(-tau*c(+1) + tau*c - z(+1) + R - pi(+1));
  0 = (exp(pi) - 1)*((1 - 1/(2*nu))*exp(pi) + 1/(2*nu))
      - beta*(exp(pi(+1)) - 1)*exp(-tau*c(+1) + tau*c + y(+1) - y + pi(+1))
      + ((1 - nu)/(nu*phi*pi_star^2))*(1 - exp(tau*c));
  exp(c - y) = exp(-g) - (phi*pi_star^2*g_star/2)*(exp(pi) - 1)^2;
  R = rho_R*R(-1) + (1 - rho_R)*(psi_1*pi
        + psi_2*(y - g)) + eR;
  g = rho_g*g(-1) + eg;
  z = rho_z*z(-1) + ez;
end;


%-------------------------------------------------------------------------------
% Defining the shocks
%-------------------------------------------------------------------------------
shocks;
  var eg; stderr 0.006;
  var eR; stderr 0.002;
  var ez; stderr 0.003;
end;


%-------------------------------------------------------------------------------
% Simulating IRFs
%-------------------------------------------------------------------------------
stoch_simul(order = 1, nodisplay);
