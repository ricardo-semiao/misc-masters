function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = rrp_qMF.static_g1_tt(T, y, x, params);
end
g1 = zeros(79, 79);
g1(1,1)=(-(1-params(10)));
g1(1,2)=1;
g1(1,3)=y(8)-T(1);
g1(1,4)=1;
g1(1,5)=(-(y(3)*getPowerDeriv(y(5),(-1),1)));
g1(1,6)=(-(params(10)*y(11)));
g1(1,8)=y(3);
g1(1,11)=(-(params(10)*y(6)));
g1(2,5)=(-(params(1)*y(8)*T(34)));
g1(2,8)=(-(params(1)*y(5)*T(34)));
g1(3,2)=(-(y(12)/y(7)*T(2)*getPowerDeriv(y(2),params(2),1)));
g1(3,6)=(-(T(3)*y(12)/y(7)*T(51)));
g1(3,7)=(-(T(3)*T(2)*(-y(12))/(y(7)*y(7))));
g1(3,11)=1;
g1(3,12)=(-(T(3)*T(2)*1/y(7)));
g1(4,5)=(-(params(6)*T(35)))/(1-params(6));
g1(4,13)=(-(1/y(14)*T(55)));
g1(4,14)=(-(T(55)*(-y(13))/(y(14)*y(14))));
g1(4,23)=(-(params(6)*T(4)*log(y(5))))/(1-params(6))-T(6)*(1+y(23)*(params(5)-1)-(y(23)-1)*(params(5)-1))/((1+y(23)*(params(5)-1))*(1+y(23)*(params(5)-1)))*log(y(13)/y(14));
g1(5,1)=(-T(8));
g1(5,2)=(-(y(1)*y(7)*getPowerDeriv(y(2),(-params(2)),1)));
g1(5,5)=(-(y(13)*params(1)*params(6)*T(35)));
g1(5,7)=(-(y(1)*T(7)));
g1(5,13)=1-T(4)*params(1)*params(6);
g1(5,23)=(-(y(13)*params(1)*params(6)*T(4)*log(y(5))));
g1(6,1)=(-(T(10)*1/y(15)*T(32)));
g1(6,5)=(-(y(14)*params(1)*params(6)*T(36)));
g1(6,6)=(-(T(11)*y(12)*T(9)*T(51)));
g1(6,12)=(-(T(11)*T(2)*T(9)));
g1(6,14)=1-params(1)*params(6)*T(12);
g1(6,15)=(-(T(10)*T(32)*(-y(1))/(y(15)*y(15))));
g1(6,23)=(-(T(11)*T(2)*y(12)*((y(23)-1)*params(5)-y(23)*params(5))/((y(23)-1)*(y(23)-1))+y(14)*params(1)*params(6)*T(12)*params(5)*log(y(5))));
g1(7,3)=1;
g1(7,5)=(-(T(13)*((-y(17))/(y(5)*y(5))+(-(y(27)*(y(5)+y(5))))/(y(5)*y(5)*y(5)*y(5))+(-(y(28)*y(29)*(y(5)+y(5))))/(y(5)*y(5)*y(29)*y(5)*y(5)*y(29))+(-(y(30)*y(31)*y(29)*(y(5)+y(5))))/T(37)+(-(y(32)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(38)+(-(y(34)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(39)+(-(y(36)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(40)+(-(y(38)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(41)+(-(y(40)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/(T(15)*T(15))+(-(y(42)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(42)+(-(y(44)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(46)+(-(y(52)*T(47)))/(T(17)*T(17))+(-(y(54)*y(55)*T(47)))/T(48)+(-(y(56)*y(57)*y(55)*T(47)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*T(47)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/(T(15)*T(15)))+T(13)*params(38)*((-y(18))/(y(5)*y(5))+(-(y(62)*(y(5)+y(5))))/(y(5)*y(5)*y(5)*y(5))+(-(y(63)*y(29)*(y(5)+y(5))))/(y(5)*y(5)*y(29)*y(5)*y(5)*y(29))+(-(y(64)*y(31)*y(29)*(y(5)+y(5))))/T(37)+(-(y(65)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(38)+(-(y(66)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(39)+(-(y(67)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(40)+(-(y(68)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(41)+(-(y(69)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/(T(15)*T(15))+(-(y(70)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(42)+(-(y(71)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/T(46)+(-(y(75)*T(47)))/(T(17)*T(17))+(-(y(76)*y(55)*T(47)))/T(48)+(-(y(77)*y(57)*y(55)*T(47)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*T(47)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*y(41)*y(39)*y(37)*y(35)*y(33)*y(31)*y(29)*(y(5)+y(5))))/(T(15)*T(15)))));
g1(7,16)=(-1);
g1(7,17)=(-(T(13)*(1+1/y(5))));
g1(7,18)=(-(T(13)*params(38)*(1+1/y(5))));
g1(7,27)=(-(T(13)*1/(y(5)*y(5))));
g1(7,28)=(-(T(13)*1/(y(5)*y(5)*y(29))));
g1(7,29)=(-(T(13)*((-(y(5)*y(5)*y(28)))/(y(5)*y(5)*y(29)*y(5)*y(5)*y(29))+(-(y(30)*y(5)*y(5)*y(31)))/T(37)+(-(y(32)*y(33)*y(5)*y(5)*y(31)))/T(38)+(-(y(34)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(39)+(-(y(36)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(40)+(-(y(38)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(41)+(-(y(40)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/(T(15)*T(15))+(-(y(42)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(42)+(-(y(44)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/(T(17)*T(17))+(-(y(54)*T(57)))/T(48)+(-(y(56)*y(57)*T(57)))/T(49)+(-(y(58)*y(59)*y(57)*T(57)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/(T(15)*T(15)))+T(13)*params(38)*((-(y(5)*y(5)*y(63)))/(y(5)*y(5)*y(29)*y(5)*y(5)*y(29))+(-(y(64)*y(5)*y(5)*y(31)))/T(37)+(-(y(65)*y(33)*y(5)*y(5)*y(31)))/T(38)+(-(y(66)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(39)+(-(y(67)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(40)+(-(y(68)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(41)+(-(y(69)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/(T(15)*T(15))+(-(y(70)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(42)+(-(y(71)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/(T(17)*T(17))+(-(y(76)*T(57)))/T(48)+(-(y(77)*y(57)*T(57)))/T(49)+(-(y(78)*y(59)*y(57)*T(57)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*y(41)*y(39)*y(37)*y(35)*y(33)*y(5)*y(5)*y(31)))/(T(15)*T(15)))));
g1(7,30)=(-(T(13)*1/(y(5)*y(5)*y(29)*y(31))));
g1(7,31)=(-(T(13)*((-(y(5)*y(5)*y(29)*y(30)))/T(37)+(-(y(32)*y(5)*y(5)*y(29)*y(33)))/T(38)+(-(y(34)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(39)+(-(y(36)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(40)+(-(y(38)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(41)+(-(y(40)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/(T(15)*T(15))+(-(y(42)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(42)+(-(y(44)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/(T(17)*T(17))+(-(y(54)*T(58)))/T(48)+(-(y(56)*y(57)*T(58)))/T(49)+(-(y(58)*y(59)*y(57)*T(58)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/(T(15)*T(15)))+T(13)*params(38)*((-(y(5)*y(5)*y(29)*y(64)))/T(37)+(-(y(65)*y(5)*y(5)*y(29)*y(33)))/T(38)+(-(y(66)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(39)+(-(y(67)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(40)+(-(y(68)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(41)+(-(y(69)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/(T(15)*T(15))+(-(y(70)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(42)+(-(y(71)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/(T(17)*T(17))+(-(y(76)*T(58)))/T(48)+(-(y(77)*y(57)*T(58)))/T(49)+(-(y(78)*y(59)*y(57)*T(58)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*y(41)*y(39)*y(37)*y(35)*y(5)*y(5)*y(29)*y(33)))/(T(15)*T(15)))));
g1(7,32)=(-(T(13)*1/(y(5)*y(5)*y(29)*y(31)*y(33))));
g1(7,33)=(-(T(13)*((-(y(5)*y(5)*y(29)*y(31)*y(32)))/T(38)+(-(y(34)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(39)+(-(y(36)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(40)+(-(y(38)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(41)+(-(y(40)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/(T(15)*T(15))+(-(y(42)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(42)+(-(y(44)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/(T(17)*T(17))+(-(y(54)*T(59)))/T(48)+(-(y(56)*y(57)*T(59)))/T(49)+(-(y(58)*y(59)*y(57)*T(59)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/(T(15)*T(15)))+T(13)*params(38)*((-(y(5)*y(5)*y(29)*y(31)*y(65)))/T(38)+(-(y(66)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(39)+(-(y(67)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(40)+(-(y(68)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(41)+(-(y(69)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/(T(15)*T(15))+(-(y(70)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(42)+(-(y(71)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/(T(17)*T(17))+(-(y(76)*T(59)))/T(48)+(-(y(77)*y(57)*T(59)))/T(49)+(-(y(78)*y(59)*y(57)*T(59)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*y(41)*y(39)*y(37)*y(5)*y(5)*y(29)*y(31)*y(35)))/(T(15)*T(15)))));
g1(7,34)=(-(T(13)*1/T(14)));
g1(7,35)=(-(T(13)*((-(y(5)*y(5)*y(29)*y(31)*y(33)*y(34)))/T(39)+(-(y(36)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(40)+(-(y(38)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(41)+(-(y(40)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/(T(15)*T(15))+(-(y(42)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(42)+(-(y(44)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/(T(17)*T(17))+(-(y(54)*T(60)))/T(48)+(-(y(56)*y(57)*T(60)))/T(49)+(-(y(58)*y(59)*y(57)*T(60)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/(T(15)*T(15)))+T(13)*params(38)*((-(y(5)*y(5)*y(29)*y(31)*y(33)*y(66)))/T(39)+(-(y(67)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(40)+(-(y(68)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(41)+(-(y(69)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/(T(15)*T(15))+(-(y(70)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(42)+(-(y(71)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/(T(17)*T(17))+(-(y(76)*T(60)))/T(48)+(-(y(77)*y(57)*T(60)))/T(49)+(-(y(78)*y(59)*y(57)*T(60)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*y(41)*y(39)*y(5)*y(5)*y(29)*y(31)*y(33)*y(37)))/(T(15)*T(15)))));
g1(7,36)=(-(T(13)*1/(T(14)*y(37))));
g1(7,37)=(-(T(13)*((-(T(14)*y(36)))/T(40)+(-(y(38)*T(14)*y(39)))/T(41)+(-(y(40)*y(41)*T(14)*y(39)))/(T(15)*T(15))+(-(y(42)*y(43)*y(41)*T(14)*y(39)))/T(42)+(-(y(44)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*y(41)*T(14)*y(39)))/(T(15)*T(15)))+T(13)*params(38)*((-(T(14)*y(67)))/T(40)+(-(y(68)*T(14)*y(39)))/T(41)+(-(y(69)*y(41)*T(14)*y(39)))/(T(15)*T(15))+(-(y(70)*y(43)*y(41)*T(14)*y(39)))/T(42)+(-(y(71)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(41)*T(14)*y(39)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*y(41)*T(14)*y(39)))/(T(15)*T(15)))));
g1(7,38)=(-(T(13)*1/(T(14)*y(37)*y(39))));
g1(7,39)=(-(T(13)*((-(T(14)*y(37)*y(38)))/T(41)+(-(y(40)*T(14)*y(37)*y(41)))/(T(15)*T(15))+(-(y(42)*y(43)*T(14)*y(37)*y(41)))/T(42)+(-(y(44)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(43)+(-(y(46)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(60)*T(14)*y(37)*y(41)))/(T(15)*T(15)))+T(13)*params(38)*((-(T(14)*y(37)*y(68)))/T(41)+(-(y(69)*T(14)*y(37)*y(41)))/(T(15)*T(15))+(-(y(70)*y(43)*T(14)*y(37)*y(41)))/T(42)+(-(y(71)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(43)+(-(y(72)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*T(14)*y(37)*y(41)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(y(79)*T(14)*y(37)*y(41)))/(T(15)*T(15)))));
g1(7,40)=(-(T(13)*1/T(15)));
g1(7,41)=(-(T(13)*((-(T(14)*y(37)*y(39)*y(40)))/(T(15)*T(15))+(-(y(42)*T(14)*y(37)*y(39)*y(43)))/T(42)+(-(y(44)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(43)+(-(y(46)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(44)+(-(y(48)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(T(14)*y(37)*y(39)*y(60)))/(T(15)*T(15)))+T(13)*params(38)*((-(T(14)*y(37)*y(39)*y(69)))/(T(15)*T(15))+(-(y(70)*T(14)*y(37)*y(39)*y(43)))/T(42)+(-(y(71)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(43)+(-(y(72)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(44)+(-(y(73)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*T(14)*y(37)*y(39)*y(43)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*(-(T(14)*y(37)*y(39)*y(79)))/(T(15)*T(15)))));
g1(7,42)=(-(T(13)*1/(T(15)*y(43))));
g1(7,43)=(-(T(13)*((-(T(15)*y(42)))/T(42)+(-(y(44)*T(15)*y(45)))/T(43)+(-(y(46)*y(47)*T(15)*y(45)))/T(44)+(-(y(48)*y(49)*y(47)*T(15)*y(45)))/T(45)+(-(y(50)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(60)/T(15))+T(13)*params(38)*((-(T(15)*y(70)))/T(42)+(-(y(71)*T(15)*y(45)))/T(43)+(-(y(72)*y(47)*T(15)*y(45)))/T(44)+(-(y(73)*y(49)*y(47)*T(15)*y(45)))/T(45)+(-(y(74)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*T(15)*y(45)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(79)/T(15))));
g1(7,44)=(-(T(13)*1/(T(15)*y(43)*y(45))));
g1(7,45)=(-(T(13)*((-(T(15)*y(43)*y(44)))/T(43)+(-(y(46)*T(15)*y(43)*y(47)))/T(44)+(-(y(48)*y(49)*T(15)*y(43)*y(47)))/T(45)+(-(y(50)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(46)+(-(y(52)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(15)*y(43)*y(71)))/T(43)+(-(y(72)*T(15)*y(43)*y(47)))/T(44)+(-(y(73)*y(49)*T(15)*y(43)*y(47)))/T(45)+(-(y(74)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(46)+(-(y(75)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*T(15)*y(43)*y(47)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(43)*y(79)/T(15))));
g1(7,46)=(-(T(13)*1/(T(15)*y(43)*y(45)*y(47))));
g1(7,47)=(-(T(13)*((-(T(15)*y(43)*y(45)*y(46)))/T(44)+(-(y(48)*T(15)*y(43)*y(45)*y(49)))/T(45)+(-(y(50)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(46)+(-(y(52)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(45)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(15)*y(43)*y(45)*y(72)))/T(44)+(-(y(73)*T(15)*y(43)*y(45)*y(49)))/T(45)+(-(y(74)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(46)+(-(y(75)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*y(51)*T(15)*y(43)*y(45)*y(49)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(45)*y(43)*y(79)/T(15))));
g1(7,48)=(-(T(13)*1/(T(15)*y(43)*y(45)*y(47)*y(49))));
g1(7,49)=(-(T(13)*((-(T(15)*y(43)*y(45)*y(47)*y(48)))/T(45)+(-(y(50)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(46)+(-(y(52)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/(T(17)*T(17))+(-(y(54)*y(55)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(48)+(-(y(56)*y(57)*y(55)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(47)*y(45)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(15)*y(43)*y(45)*y(47)*y(73)))/T(45)+(-(y(74)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(46)+(-(y(75)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/(T(17)*T(17))+(-(y(76)*y(55)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(48)+(-(y(77)*y(57)*y(55)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*y(53)*T(15)*y(43)*y(45)*y(47)*y(51)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(51)*y(47)*y(45)*y(43)*y(79)/T(15))));
g1(7,50)=(-(T(13)*1/T(16)));
g1(7,51)=(-(T(13)*((-(T(15)*y(43)*y(45)*y(47)*y(49)*y(50)))/T(46)+(-(y(52)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/(T(17)*T(17))+(-(y(54)*y(55)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/T(48)+(-(y(56)*y(57)*y(55)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/T(49)+(-(y(58)*y(59)*y(57)*y(55)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(49)*y(47)*y(45)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(15)*y(43)*y(45)*y(47)*y(49)*y(74)))/T(46)+(-(y(75)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/(T(17)*T(17))+(-(y(76)*y(55)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/T(48)+(-(y(77)*y(57)*y(55)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/T(49)+(-(y(78)*y(59)*y(57)*y(55)*T(15)*y(43)*y(45)*y(47)*y(49)*y(53)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(53)*y(49)*y(47)*y(45)*y(43)*y(79)/T(15))));
g1(7,52)=(-(T(13)*1/T(17)));
g1(7,53)=(-(T(13)*((-(T(16)*y(52)))/(T(17)*T(17))+(-(y(54)*T(16)*y(55)))/T(48)+(-(y(56)*y(57)*T(16)*y(55)))/T(49)+(-(y(58)*y(59)*y(57)*T(16)*y(55)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(51)*y(49)*y(47)*y(45)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(16)*y(75)))/(T(17)*T(17))+(-(y(76)*T(16)*y(55)))/T(48)+(-(y(77)*y(57)*T(16)*y(55)))/T(49)+(-(y(78)*y(59)*y(57)*T(16)*y(55)))/T(50)+y(61)*y(59)*y(57)*y(55)*y(51)*y(49)*y(47)*y(45)*y(43)*y(79)/T(15))));
g1(7,54)=(-(T(13)*1/(T(17)*y(55))));
g1(7,55)=(-(T(13)*((-(T(17)*y(54)))/T(48)+(-(y(56)*T(17)*y(57)))/T(49)+(-(y(58)*y(59)*T(17)*y(57)))/T(50)+y(61)*y(59)*y(57)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(17)*y(76)))/T(48)+(-(y(77)*T(17)*y(57)))/T(49)+(-(y(78)*y(59)*T(17)*y(57)))/T(50)+y(61)*y(59)*y(57)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(79)/T(15))));
g1(7,56)=(-(T(13)*1/(T(17)*y(55)*y(57))));
g1(7,57)=(-(T(13)*((-(T(17)*y(55)*y(56)))/T(49)+(-(y(58)*T(17)*y(55)*y(59)))/T(50)+y(61)*y(59)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(60)/T(15))+T(13)*params(38)*((-(T(17)*y(55)*y(77)))/T(49)+(-(y(78)*T(17)*y(55)*y(59)))/T(50)+y(61)*y(59)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(79)/T(15))));
g1(7,58)=(-(T(13)*1/(T(17)*y(55)*y(57)*y(59))));
g1(7,59)=(-(T(13)*((-(T(17)*y(55)*y(57)*y(58)))/T(50)+y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(60)/T(15)*y(61))+T(13)*params(38)*((-(T(17)*y(55)*y(57)*y(78)))/T(50)+y(61)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(79)/T(15))));
g1(7,60)=(-(T(13)*T(61)));
g1(7,61)=(-(T(13)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(60)/T(15)+T(13)*params(38)*y(59)*y(57)*y(55)*y(53)*y(51)*y(49)*y(47)*y(45)*y(43)*y(79)/T(15)));
g1(7,62)=(-(T(13)*params(38)*1/(y(5)*y(5))));
g1(7,63)=(-(T(13)*params(38)*1/(y(5)*y(5)*y(29))));
g1(7,64)=(-(T(13)*params(38)*1/(y(5)*y(5)*y(29)*y(31))));
g1(7,65)=(-(T(13)*params(38)*1/(y(5)*y(5)*y(29)*y(31)*y(33))));
g1(7,66)=(-(T(13)*params(38)*1/T(14)));
g1(7,67)=(-(T(13)*params(38)*1/(T(14)*y(37))));
g1(7,68)=(-(T(13)*params(38)*1/(T(14)*y(37)*y(39))));
g1(7,69)=(-(T(13)*params(38)*1/T(15)));
g1(7,70)=(-(T(13)*params(38)*1/(T(15)*y(43))));
g1(7,71)=(-(T(13)*params(38)*1/(T(15)*y(43)*y(45))));
g1(7,72)=(-(T(13)*params(38)*1/(T(15)*y(43)*y(45)*y(47))));
g1(7,73)=(-(T(13)*params(38)*1/(T(15)*y(43)*y(45)*y(47)*y(49))));
g1(7,74)=(-(T(13)*params(38)*1/T(16)));
g1(7,75)=(-(T(13)*params(38)*1/T(17)));
g1(7,76)=(-(T(13)*params(38)*1/(T(17)*y(55))));
g1(7,77)=(-(T(13)*params(38)*1/(T(17)*y(55)*y(57))));
g1(7,78)=(-(T(13)*params(38)*1/(T(17)*y(55)*y(57)*y(59))));
g1(7,79)=(-(T(13)*params(38)*T(61)));
g1(8,10)=(-((-1)/(y(10)*y(10))));
g1(8,20)=1;
g1(9,9)=1;
g1(9,21)=(-((T(19)*(T(18)*(-params(8))/(params(8)*(1+y(21))*params(8)*(1+y(21)))+1/(params(8)*(1+y(21)))*(-((-1)/((1+y(21))*(1+y(21)))*getPowerDeriv(1/(1+y(21)),params(8),1))))-1/(params(8)*(1+y(21)))*T(18)*(-((-1)/((1+y(21))*(1+y(21))))))/(T(19)*T(19))));
g1(10,3)=(-y(8));
g1(10,8)=(-y(3));
g1(10,26)=1;
g1(11,3)=(-(T(21)*y(8)/y(10)));
g1(11,8)=(-(T(21)*y(3)/y(10)));
g1(11,9)=(-(T(21)*(-params(15))/y(10)+T(20)*T(53)));
g1(11,10)=(-(T(21)*(y(10)*(-params(14))-(y(8)*y(3)-y(10)*params(14)-y(9)*params(15)))/(y(10)*y(10))+T(20)*T(54)));
g1(11,16)=1;
g1(12,3)=(-(T(23)*y(8)/y(9)));
g1(12,8)=(-(T(23)*y(3)/y(9)));
g1(12,9)=(-(T(23)*(y(9)*(-params(15))-(y(8)*y(3)-y(10)*params(14)-y(9)*params(15)))/(y(9)*y(9))+T(22)*(-T(53))));
g1(12,10)=(-(T(23)*(-params(14))/y(9)+T(22)*(-T(54))));
g1(12,17)=1;
g1(13,18)=1;
g1(14,1)=(-(y(24)*T(25)*1/params(27)*getPowerDeriv(T(26),params(24),1)));
g1(14,5)=(-(y(24)*T(27)*1/params(7)*getPowerDeriv(T(24),params(23),1)));
g1(14,20)=1/(1+params(37));
g1(14,24)=(-(T(25)*T(27)));
g1(15,1)=(-(y(25)*T(28)*1/params(27)*getPowerDeriv(T(26),params(26),1)));
g1(15,5)=(-(y(25)*T(29)*1/params(7)*getPowerDeriv(T(24),params(25),1)));
g1(15,18)=(y(18)-(y(18)-1/(1-params(38))*y(19)))/(y(18)*y(18));
g1(15,19)=(-(1/(1-params(38))))/y(18);
g1(15,25)=(-(T(28)*T(29)));
g1(16,17)=(-1);
g1(16,18)=1-params(38);
g1(16,19)=(-1);
g1(17,1)=1;
g1(17,2)=(-1);
g1(17,4)=(-1);
g1(18,1)=1;
g1(18,6)=(-(y(15)*1/y(22)*T(52)));
g1(18,15)=(-T(30));
g1(18,22)=(-(y(15)*T(52)*(-y(6))/(y(22)*y(22))));
g1(19,5)=(-((1-params(6))*(-(params(6)*T(35)))/(1-params(6))*getPowerDeriv(T(5),T(9),1)+y(22)*params(6)*T(36)));
g1(19,22)=1-params(6)*T(12);
g1(19,23)=(-((1-params(6))*T(31)*(((y(23)-1)*params(5)-y(23)*params(5))/((y(23)-1)*(y(23)-1))*log(T(5))+T(9)*(-(params(6)*T(4)*log(y(5))))/(1-params(6))/T(5))+y(22)*params(6)*T(12)*params(5)*log(y(5))));
g1(20,7)=1/y(7)-params(18)*1/y(7);
g1(21,12)=1/y(12)-params(19)*1/y(12);
g1(22,15)=1/y(15)-params(21)*1/y(15);
g1(23,23)=T(56)-params(22)*T(56);
g1(24,4)=T(33)-params(20)*T(33);
g1(25,24)=1/y(24)-params(16)*1/y(24);
g1(26,25)=1/y(25)-params(17)*1/y(25);
g1(27,17)=(-1);
g1(27,27)=1;
g1(28,27)=(-1);
g1(28,28)=1;
g1(29,5)=(-1);
g1(29,29)=1;
g1(30,28)=(-1);
g1(30,30)=1;
g1(31,29)=(-1);
g1(31,31)=1;
g1(32,30)=(-1);
g1(32,32)=1;
g1(33,31)=(-1);
g1(33,33)=1;
g1(34,32)=(-1);
g1(34,34)=1;
g1(35,33)=(-1);
g1(35,35)=1;
g1(36,34)=(-1);
g1(36,36)=1;
g1(37,35)=(-1);
g1(37,37)=1;
g1(38,36)=(-1);
g1(38,38)=1;
g1(39,37)=(-1);
g1(39,39)=1;
g1(40,38)=(-1);
g1(40,40)=1;
g1(41,39)=(-1);
g1(41,41)=1;
g1(42,40)=(-1);
g1(42,42)=1;
g1(43,41)=(-1);
g1(43,43)=1;
g1(44,42)=(-1);
g1(44,44)=1;
g1(45,43)=(-1);
g1(45,45)=1;
g1(46,44)=(-1);
g1(46,46)=1;
g1(47,45)=(-1);
g1(47,47)=1;
g1(48,46)=(-1);
g1(48,48)=1;
g1(49,47)=(-1);
g1(49,49)=1;
g1(50,48)=(-1);
g1(50,50)=1;
g1(51,49)=(-1);
g1(51,51)=1;
g1(52,50)=(-1);
g1(52,52)=1;
g1(53,51)=(-1);
g1(53,53)=1;
g1(54,52)=(-1);
g1(54,54)=1;
g1(55,53)=(-1);
g1(55,55)=1;
g1(56,54)=(-1);
g1(56,56)=1;
g1(57,55)=(-1);
g1(57,57)=1;
g1(58,56)=(-1);
g1(58,58)=1;
g1(59,57)=(-1);
g1(59,59)=1;
g1(60,58)=(-1);
g1(60,60)=1;
g1(61,59)=(-1);
g1(61,61)=1;
g1(62,18)=(-1);
g1(62,62)=1;
g1(63,62)=(-1);
g1(63,63)=1;
g1(64,63)=(-1);
g1(64,64)=1;
g1(65,64)=(-1);
g1(65,65)=1;
g1(66,65)=(-1);
g1(66,66)=1;
g1(67,66)=(-1);
g1(67,67)=1;
g1(68,67)=(-1);
g1(68,68)=1;
g1(69,68)=(-1);
g1(69,69)=1;
g1(70,69)=(-1);
g1(70,70)=1;
g1(71,70)=(-1);
g1(71,71)=1;
g1(72,71)=(-1);
g1(72,72)=1;
g1(73,72)=(-1);
g1(73,73)=1;
g1(74,73)=(-1);
g1(74,74)=1;
g1(75,74)=(-1);
g1(75,75)=1;
g1(76,75)=(-1);
g1(76,76)=1;
g1(77,76)=(-1);
g1(77,77)=1;
g1(78,77)=(-1);
g1(78,78)=1;
g1(79,78)=(-1);
g1(79,79)=1;

end
