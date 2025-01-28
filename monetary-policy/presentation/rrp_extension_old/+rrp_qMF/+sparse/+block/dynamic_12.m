function [y, T, residual, g1] = dynamic_12(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(1, 1);
  T(50)=1-(1/(1+y(100)))^params(8);
  residual(1)=(y(88))-(1/(params(8)*(1+y(100)))*T(50)/(1-1/(1+y(100))));
if nargout > 3
    g1_v = NaN(1, 1);
g1_v(1)=(-(((1-1/(1+y(100)))*(T(50)*(-params(8))/(params(8)*(1+y(100))*params(8)*(1+y(100)))+1/(params(8)*(1+y(100)))*(-((-1)/((1+y(100))*(1+y(100)))*getPowerDeriv(1/(1+y(100)),params(8),1))))-1/(params(8)*(1+y(100)))*T(50)*(-((-1)/((1+y(100))*(1+y(100))))))/((1-1/(1+y(100)))*(1-1/(1+y(100))))));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 1, 1);
end
end
