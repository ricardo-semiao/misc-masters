function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
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

assert(length(T) >= 68);

T = rrp_qMF.dynamic_resid_tt(T, y, x, params, steady_state, it_);

T(40) = getPowerDeriv(y(66)/y(80),params(5),1);
T(41) = getPowerDeriv(y(145)/y(67),(-params(2)),1);
T(42) = y(70)*y(3)*y(15)*y(17)*y(70)*y(3)*y(15)*y(17);
T(43) = y(70)*y(3)*y(15)*y(17)*y(19)*y(70)*y(3)*y(15)*y(17)*y(19);
T(44) = T(36)*T(36);
T(45) = T(36)*y(23)*T(36)*y(23);
T(46) = T(36)*y(23)*y(25)*T(36)*y(23)*y(25);
T(47) = T(37)*y(29)*T(37)*y(29);
T(48) = T(37)*y(29)*y(31)*T(37)*y(29)*y(31);
T(49) = T(37)*y(29)*y(31)*y(33)*T(37)*y(29)*y(31)*y(33);
T(50) = T(37)*y(29)*y(31)*y(33)*y(35)*T(37)*y(29)*y(31)*y(33)*y(35);
T(51) = T(38)*T(38);
T(52) = y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(27)*y(25)*y(23)*y(21)*y(19)*y(17)*y(70)*y(15);
T(53) = T(39)*y(41)*T(39)*y(41);
T(54) = T(39)*y(41)*y(43)*T(39)*y(41)*y(43);
T(55) = T(39)*y(41)*y(43)*y(45)*T(39)*y(41)*y(43)*y(45);
T(56) = (-(params(6)*getPowerDeriv(y(70),y(88)-1,1)))/(1-params(6));
T(57) = y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(27)*y(25)*y(23)*y(21)*y(19)*y(17)*y(3)*y(15);
T(58) = getPowerDeriv(y(73)*y(146),(-1),1);
T(59) = getPowerDeriv(y(71),params(3),1);
T(60) = getPowerDeriv(y(71)/y(87),1/params(5),1);
T(61) = params(13)*(-y(75))/(y(74)*y(74))/(y(75)/y(74));
T(62) = params(13)*1/y(74)/(y(75)/y(74));
T(63) = getPowerDeriv(y(78)/y(79),(y(88)-1)/(1+y(88)*(params(5)-1)),1);
T(64) = y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(27)*y(25)*y(23)*y(21)*y(19)*y(70)*y(3)*y(17);
T(65) = y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(27)*y(25)*y(23)*y(21)*y(70)*y(3)*y(15)*y(19);
T(66) = y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(27)*y(25)*y(23)*y(70)*y(3)*y(15)*y(17)*y(21);
T(67) = y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(27)*y(25)*y(70)*y(3)*y(15)*y(17)*y(19)*y(23);
T(68) = y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*1/T(37);

end
