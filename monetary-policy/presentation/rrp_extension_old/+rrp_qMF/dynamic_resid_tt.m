function T = dynamic_resid_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_resid_tt(T, y, x, params, steady_state, it_)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double  vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double  vector of endogenous variables in the order stored
%                                                    in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double  matrix of exogenous variables (in declaration order)
%                                                    for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double  vector of steady state values
%   params        [M_.param_nbr by 1]        double  vector of parameter values in declaration order
%   it_           scalar                     double  time period for exogenous variables for which
%                                                    to evaluate the model
%
% Output:
%   T           [#temp variables by 1]       double  vector of temporary terms
%

assert(length(T) >= 39);

T(1) = y(70)^(-1);
T(2) = (y(145)/y(67))^(-params(2));
T(3) = params(1)*y(147)/y(72)*T(2);
T(4) = (y(73)*y(146))^(-1);
T(5) = y(71)^params(3);
T(6) = y(67)^params(2);
T(7) = y(70)^(y(88)-1);
T(8) = (1-params(6)*T(7))/(1-params(6));
T(9) = (y(78)/y(79))^((y(88)-1)/(1+y(88)*(params(5)-1)));
T(10) = y(67)^(-params(2));
T(11) = y(72)*T(10);
T(12) = y(146)^(y(88)-1);
T(13) = params(1)*params(6)*T(12);
T(14) = y(88)*params(5)/(y(88)-1);
T(15) = T(5)*y(77)*T(14);
T(16) = (y(66)/y(80))^params(5);
T(17) = y(146)^(y(88)*params(5));
T(18) = params(1)*params(6)*T(17);
T(19) = 1/params(8);
T(20) = 1-(1/(1+y(86)))^params(8);
T(21) = 1-1/(1+y(86));
T(22) = (y(73)*y(68)-y(75)*params(14)-y(74)*params(15))/y(75);
T(23) = params(12)+params(13)*log(y(75)/y(74));
T(24) = (y(73)*y(68)-y(75)*params(14)-y(74)*params(15))/y(74);
T(25) = 1-params(12)-params(13)*log(y(75)/y(74));
T(26) = y(70)/params(7);
T(27) = T(26)^params(23);
T(28) = y(66)/params(27);
T(29) = T(28)^params(24);
T(30) = T(26)^params(25);
T(31) = T(28)^params(26);
T(32) = (y(71)/y(87))^(1/params(5));
T(33) = T(8)^T(14);
T(34) = y(70)^(y(88)*params(5));
T(35) = params(6)*T(34);
T(36) = y(70)*y(3)*y(15)*y(17)*y(19)*y(21);
T(37) = T(36)*y(23)*y(25)*y(27);
T(38) = T(37)*y(29)*y(31)*y(33)*y(35)*y(37);
T(39) = T(38)*y(39);

end
