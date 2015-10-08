function result = yhat(x, coefficient)
  [~,r] = size(x);
  z = dimExpand(x, (length(coefficient)-1)/r);
  result = z * coefficient;
end
