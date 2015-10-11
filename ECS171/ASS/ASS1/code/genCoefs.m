function coefficients = genCoefs(x,y)
% This function is simple, just calls the regression function five times to
% generate five coefficients and after that combine them into a cell.
  n = length(y);
  coefficients = {};
  coefficients{1} = singlePolyReg(x(1:n),y(1:n),0);
  coefficients{2} = singlePolyReg(x(1:n),y(1:n),1);
  coefficients{3} = singlePolyReg(x(1:n),y(1:n),2);
  coefficients{4} = singlePolyReg(x(1:n),y(1:n),3);
  coefficients{5} = singlePolyReg(x(1:n),y(1:n),4);
end
