function result = yhat(x, coefficient)
% This function calculates the predicted Y(dependent) value for polynomial
% regression.
  [~,r] = size(x);
  z = dimExpand(x, (length(coefficient)-1)/r);
  result = z * coefficient;
end
