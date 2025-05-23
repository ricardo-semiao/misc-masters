function [y, T, residual, g1] = static_7(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(1, 1);
  T(6)=log(y(24));
  residual(1)=(T(6))-(T(6)*params(16)-x(6));
if nargout > 3
    g1_v = NaN(1, 1);
g1_v(1)=1/y(24)-params(16)*1/y(24);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 1, 1);
end
end
