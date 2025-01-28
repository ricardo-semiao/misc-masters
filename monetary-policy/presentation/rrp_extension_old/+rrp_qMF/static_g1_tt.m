function T = static_g1_tt(T, y, x, params)
% function T = static_g1_tt(T, y, x, params)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%
% Output:
%   T         [#temp variables by 1]  double   vector of temporary terms
%

assert(length(T) >= 61);

T = rrp_qMF.static_resid_tt(T, y, x, params);

T(32) = getPowerDeriv(y(1)/y(15),params(5),1);
T(33) = 1/params(28)/(y(4)/params(28));
T(34) = getPowerDeriv(y(8)*y(5),(-1),1);
T(35) = getPowerDeriv(y(5),y(23)-1,1);
T(36) = getPowerDeriv(y(5),y(23)*params(5),1);
T(37) = y(5)*y(5)*y(29)*y(31)*y(5)*y(5)*y(29)*y(31);
T(38) = y(5)*y(5)*y(29)*y(31)*y(33)*y(5)*y(5)*y(29)*y(31)*y(33);
T(39) = T(14)*T(14);
T(40) = T(14)*y(37)*T(14)*y(37);
T(41) = T(14)*y(37)*y(39)*T(14)*y(37)*y(39);
T(42) = T(15)*y(43)*T(15)*y(43);
T(43) = T(15)*y(43)*y(45)*T(15)*y(43)*y(45);
T(44) = T(15)*y(43)*y(45)*y(47)*T(15)*y(43)*y(45)*y(47);
T(45) = T(15)*y(43)*y(45)*y(47)*y(49)*T(15)*y(43)*y(45)*y(47)*y(49);
T(46) = T(16)*T(16);
T(47) = y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5));
T(48) = T(17)*y(55)*T(17)*y(55);
T(49) = T(17)*y(55)*y(57)*T(17)*y(55)*y(57);
T(50) = T(17)*y(55)*y(57)*y(59)*T(17)*y(55)*y(57)*y(59);
T(51) = getPowerDeriv(y(6),params(3),1);
T(52) = getPowerDeriv(y(6)/y(22),1/params(5),1);
T(53) = params(13)*(-y(10))/(y(9)*y(9))/(y(10)/y(9));
T(54) = params(13)*1/y(9)/(y(10)/y(9));
T(55) = getPowerDeriv(y(13)/y(14),(y(23)-1)/(1+y(23)*(params(5)-1)),1);
T(56) = 1/params(4)/(y(23)/params(4));
T(57) = y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31);
T(58) = y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33);
T(59) = y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35);
T(60) = y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37);
T(61) = y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*1/T(15);

end
