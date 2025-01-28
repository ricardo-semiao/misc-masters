function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = rrp_qMF.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(79, 1);
    residual(1) = (y(67)+y(73)*y(68)+y(69)) - (y(1)*T(1)+params(10)*y(76)*y(71)+(1-params(10))*y(66));
    residual(2) = (1) - (T(3)*T(4));
    residual(3) = (y(76)) - (y(77)/y(72)*T(5)*T(6));
    residual(4) = (T(8)) - (T(9));
    residual(5) = (y(78)) - (y(66)*T(11)+T(13)*y(148));
    residual(6) = (y(79)) - (T(15)*T(16)+T(18)*y(149));
    residual(7) = (y(68)) - (y(81)+T(19)*(y(82)+y(7)/y(70)+y(13)/(y(70)*y(3))+y(14)/(y(70)*y(3)*y(15))+y(16)/(y(70)*y(3)*y(15)*y(17))+y(18)/(y(70)*y(3)*y(15)*y(17)*y(19))+y(20)/T(36)+y(22)/(T(36)*y(23))+y(24)/(T(36)*y(23)*y(25))+y(26)/T(37)+y(28)/(T(37)*y(29))+y(30)/(T(37)*y(29)*y(31))+y(32)/(T(37)*y(29)*y(31)*y(33))+y(34)/(T(37)*y(29)*y(31)*y(33)*y(35))+y(36)/T(38)+y(38)/T(39)+y(40)/(T(39)*y(41))+y(42)/(T(39)*y(41)*y(43))+y(44)/(T(39)*y(41)*y(43)*y(45))+y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(46)/T(37)*y(47))+T(19)*params(38)*(y(83)+y(8)/y(70)+y(48)/(y(70)*y(3))+y(49)/(y(70)*y(3)*y(15))+y(50)/(y(70)*y(3)*y(15)*y(17))+y(51)/(y(70)*y(3)*y(15)*y(17)*y(19))+y(52)/T(36)+y(53)/(T(36)*y(23))+y(54)/(T(36)*y(23)*y(25))+y(55)/T(37)+y(56)/(T(37)*y(29))+y(57)/(T(37)*y(29)*y(31))+y(58)/(T(37)*y(29)*y(31)*y(33))+y(59)/(T(37)*y(29)*y(31)*y(33)*y(35))+y(60)/T(38)+y(61)/T(39)+y(62)/(T(39)*y(41))+y(63)/(T(39)*y(41)*y(43))+y(64)/(T(39)*y(41)*y(43)*y(45))+y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*y(65)/T(37)));
    residual(8) = (1+y(85)) - (1/y(75));
    residual(9) = (y(74)) - (1/(params(8)*(1+y(86)))*T(20)/T(21));
    residual(10) = (y(91)) - (y(73)*y(68));
    residual(11) = (y(81)) - (params(14)+T(22)*T(23));
    residual(12) = (y(82)) - (params(15)+T(24)*T(25));
    residual(13) = (y(83)) - (params(11)*params(27));
    residual(14) = ((1+y(85))/(1+params(37))) - (T(27)*T(29)*y(89));
    residual(15) = ((y(83)-1/(1-params(38))*y(84))/y(83)) - (T(30)*T(31)*y(90));
    residual(16) = (y(83)*(1-params(38))) - (y(82)+y(84));
    residual(17) = (y(66)) - (y(67)+y(69));
    residual(18) = (y(66)) - (y(80)*T(32));
    residual(19) = (y(87)) - ((1-params(6))*T(33)+T(35)*y(9));
    residual(20) = (log(y(72))) - (params(18)*log(y(4))+x(it_, 1));
    residual(21) = (log(y(77))) - (params(19)*log(y(5))+x(it_, 2));
    residual(22) = (log(y(80))) - (params(21)*log(y(6))+x(it_, 3));
    residual(23) = (log(y(88)/params(4))) - (params(22)*log(y(10)/params(4))+x(it_, 4));
    residual(24) = (log(y(69)/params(28))) - (params(20)*log(y(2)/params(28))+x(it_, 5));
    residual(25) = (log(y(89))) - (params(16)*log(y(11))-x(it_, 6));
    residual(26) = (log(y(90))) - (params(17)*log(y(12))-x(it_, 7));
    residual(27) = (y(92)) - (y(7));
    residual(28) = (y(93)) - (y(13));
    residual(29) = (y(94)) - (y(3));
    residual(30) = (y(95)) - (y(14));
    residual(31) = (y(96)) - (y(15));
    residual(32) = (y(97)) - (y(16));
    residual(33) = (y(98)) - (y(17));
    residual(34) = (y(99)) - (y(18));
    residual(35) = (y(100)) - (y(19));
    residual(36) = (y(101)) - (y(20));
    residual(37) = (y(102)) - (y(21));
    residual(38) = (y(103)) - (y(22));
    residual(39) = (y(104)) - (y(23));
    residual(40) = (y(105)) - (y(24));
    residual(41) = (y(106)) - (y(25));
    residual(42) = (y(107)) - (y(26));
    residual(43) = (y(108)) - (y(27));
    residual(44) = (y(109)) - (y(28));
    residual(45) = (y(110)) - (y(29));
    residual(46) = (y(111)) - (y(30));
    residual(47) = (y(112)) - (y(31));
    residual(48) = (y(113)) - (y(32));
    residual(49) = (y(114)) - (y(33));
    residual(50) = (y(115)) - (y(34));
    residual(51) = (y(116)) - (y(35));
    residual(52) = (y(117)) - (y(36));
    residual(53) = (y(118)) - (y(37));
    residual(54) = (y(119)) - (y(38));
    residual(55) = (y(120)) - (y(39));
    residual(56) = (y(121)) - (y(40));
    residual(57) = (y(122)) - (y(41));
    residual(58) = (y(123)) - (y(42));
    residual(59) = (y(124)) - (y(43));
    residual(60) = (y(125)) - (y(44));
    residual(61) = (y(126)) - (y(45));
    residual(62) = (y(127)) - (y(8));
    residual(63) = (y(128)) - (y(48));
    residual(64) = (y(129)) - (y(49));
    residual(65) = (y(130)) - (y(50));
    residual(66) = (y(131)) - (y(51));
    residual(67) = (y(132)) - (y(52));
    residual(68) = (y(133)) - (y(53));
    residual(69) = (y(134)) - (y(54));
    residual(70) = (y(135)) - (y(55));
    residual(71) = (y(136)) - (y(56));
    residual(72) = (y(137)) - (y(57));
    residual(73) = (y(138)) - (y(58));
    residual(74) = (y(139)) - (y(59));
    residual(75) = (y(140)) - (y(60));
    residual(76) = (y(141)) - (y(61));
    residual(77) = (y(142)) - (y(62));
    residual(78) = (y(143)) - (y(63));
    residual(79) = (y(144)) - (y(64));

end
