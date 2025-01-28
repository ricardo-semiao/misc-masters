function [y, T, residual, g1] = static_12(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(1, 1);
  T(51)=1-(1/(1+y(21)))^params(8);
  residual(1)=(y(9))-(1/(params(8)*(1+y(21)))*T(51)/(1-1/(1+y(21))));
if nargout > 3
    g1_v = NaN(1, 1);
g1_v(1)=(-(((1-1/(1+y(21)))*(T(51)*(-params(8))/(params(8)*(1+y(21))*params(8)*(1+y(21)))+1/(params(8)*(1+y(21)))*(-((-1)/((1+y(21))*(1+y(21)))*getPowerDeriv(1/(1+y(21)),params(8),1))))-1/(params(8)*(1+y(21)))*T(51)*(-((-1)/((1+y(21))*(1+y(21))))))/((1-1/(1+y(21)))*(1-1/(1+y(21))))));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 1, 1);
end
end
