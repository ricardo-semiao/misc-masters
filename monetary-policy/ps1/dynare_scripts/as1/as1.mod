// Modified version of Michel Juillard's code from Dynare Summer School 2021
// An and Schorfheide model
// see An Schorfheide (2006) and Herbst Schorfheide (2016)
// and corrections https://cpb-us-w2.wpmucdn.com/web.sas.upenn.edu/dist/e/242/files/2017/05/corrections_v1-11vpcen.pdf
// Stationary nonlinear version, variables in level
// Calibration: An and Schorfheide (2006), Table 3 and page 38.

close all;


%------------------------------------------------------------------------------
% Defining the variables and parameters of the model
%------------------------------------------------------------------------------
var c y y_star pi R R_star z g;
varexo eg ez eR;
parameters beta tau gamma phi nu pi_star r rho_R rho_z rho_g psi_1 psi_2 g_star g_bar;


%-------------------------------------------------------------------------------
% Defining the calibration
%-------------------------------------------------------------------------------
tau = 2.0;
nu = 0.1;
phi = 53.68;
kappa = 0.33;
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
g_bar = g_star;


%-------------------------------------------------------------------------------
% Defining the model
%-------------------------------------------------------------------------------
model;
    1 = beta * ( (c(+1)/c)^(-tau) ) * (1 / (gamma * exp(z(+1)))) * (R / pi(+1));      %(1)
    1 = phi * (pi - pi_star) * (1 - (1 / (2 * nu)) * pi + (pi_star / (2 * nu)))
      - phi * beta * ( (c(+1)/c)^(-tau) ) * (y(+1) / y) * (pi(+1) - pi_star) * pi(+1)
      + (1 / nu) * (1 - c^tau);                                                       %(2)
    y = c + ((g - 1) / g) * y + (phi / 2) * (pi - pi_star)^2 * y;                     %(3)
    R = R_star^(1 - rho_R) * R(-1)^rho_R * exp(eR);                                   %(4)
    R_star = r * pi_star * (pi / pi_star)^psi_1 * (y / y_star)^psi_2;                 %(5)
    z = rho_z * z(-1) + ez;                                                           %(6)
     g = (1 - rho_g) * g_bar + rho_g * g(-1) + eg;                                    %(7)
    y_star = g * c;                                                                   %(8)
end;


%-------------------------------------------------------------------------------
% Defining the steady state
%-------------------------------------------------------------------------------
steady_state_model;
    c       = (1 - nu)^(1 / tau);
    y_star  = g_star * c;
    y       = y_star;
    pi      = pi_star;
    R       = r * pi_star;
    R_star  = R;
    g       = g_star;
    z       = 0;
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
% Calculating the steady states and checking
%-------------------------------------------------------------------------------
steady;
check;


%-------------------------------------------------------------------------------
% Simulating IRFs
%-------------------------------------------------------------------------------
stoch_simul(order = 1, irf = 20, nodisplay) c y pi R z g;
