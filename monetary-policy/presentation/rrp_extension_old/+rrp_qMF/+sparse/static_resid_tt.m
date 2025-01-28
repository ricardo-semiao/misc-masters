function [T_order, T] = static_resid_tt(y, x, params, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 31
    T = [T; NaN(31 - size(T, 1), 1)];
end
T(1) = y(5)^(-1);
T(2) = y(6)^params(3);
T(3) = y(2)^params(2);
T(4) = y(5)^(y(23)-1);
T(5) = (1-params(6)*T(4))/(1-params(6));
T(6) = (y(13)/y(14))^((y(23)-1)/(1+y(23)*(params(5)-1)));
T(7) = y(2)^(-params(2));
T(8) = y(7)*T(7);
T(9) = y(23)*params(5)/(y(23)-1);
T(10) = T(2)*y(12)*T(9);
T(11) = (y(1)/y(15))^params(5);
T(12) = y(5)^(y(23)*params(5));
T(13) = 1/params(8);
T(14) = y(5)*y(5)*y(29)*y(31)*y(33)*y(35);
T(15) = T(14)*y(37)*y(39)*y(41);
T(16) = T(15)*y(43)*y(45)*y(47)*y(49)*y(51);
T(17) = T(16)*y(53);
T(18) = 1-(1/(1+y(21)))^params(8);
T(19) = 1-1/(1+y(21));
T(20) = (y(8)*y(3)-y(10)*params(14)-y(9)*params(15))/y(10);
T(21) = params(12)+params(13)*log(y(10)/y(9));
T(22) = (y(8)*y(3)-y(10)*params(14)-y(9)*params(15))/y(9);
T(23) = 1-params(12)-params(13)*log(y(10)/y(9));
T(24) = y(5)/params(7);
T(25) = T(24)^params(23);
T(26) = y(1)/params(27);
T(27) = T(26)^params(24);
T(28) = T(24)^params(25);
T(29) = T(26)^params(26);
T(30) = (y(6)/y(22))^(1/params(5));
T(31) = T(5)^T(9);
end
