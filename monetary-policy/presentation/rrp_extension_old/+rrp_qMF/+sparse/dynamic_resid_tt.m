function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 39
    T = [T; NaN(39 - size(T, 1), 1)];
end
T(1) = y(84)^(-1);
T(2) = (y(160)/y(81))^(-params(2));
T(3) = params(1)*y(165)/y(86)*T(2);
T(4) = (y(87)*y(163))^(-1);
T(5) = y(85)^params(3);
T(6) = y(81)^params(2);
T(7) = y(84)^(y(102)-1);
T(8) = (1-params(6)*T(7))/(1-params(6));
T(9) = (y(92)/y(93))^((y(102)-1)/(1+y(102)*(params(5)-1)));
T(10) = y(81)^(-params(2));
T(11) = y(86)*T(10);
T(12) = y(163)^(y(102)-1);
T(13) = params(1)*params(6)*T(12);
T(14) = y(102)*params(5)/(y(102)-1);
T(15) = T(5)*y(91)*T(14);
T(16) = (y(80)/y(94))^params(5);
T(17) = y(163)^(y(102)*params(5));
T(18) = params(1)*params(6)*T(17);
T(19) = 1/params(8);
T(20) = 1-(1/(1+y(100)))^params(8);
T(21) = 1-1/(1+y(100));
T(22) = (y(87)*y(82)-y(89)*params(14)-y(88)*params(15))/y(89);
T(23) = params(12)+params(13)*log(y(89)/y(88));
T(24) = (y(87)*y(82)-y(89)*params(14)-y(88)*params(15))/y(88);
T(25) = 1-params(12)-params(13)*log(y(89)/y(88));
T(26) = y(84)/params(7);
T(27) = T(26)^params(23);
T(28) = y(80)/params(27);
T(29) = T(28)^params(24);
T(30) = T(26)^params(25);
T(31) = T(28)^params(26);
T(32) = (y(85)/y(101))^(1/params(5));
T(33) = T(8)^T(14);
T(34) = y(84)^(y(102)*params(5));
T(35) = params(6)*T(34);
T(36) = y(84)*y(5)*y(29)*y(31)*y(33)*y(35);
T(37) = T(36)*y(37)*y(39)*y(41);
T(38) = T(37)*y(43)*y(45)*y(47)*y(49)*y(51);
T(39) = T(38)*y(53);
end
