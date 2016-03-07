function result = yhatLogistic(x,w)
% This function calculates the predicted Y(dependent) value of logistic
% regression.
    [n,~] = size(x);
    x = dimExpand(x,n);
    value = sigmoid(x,w);
    result = oddTransfer(value);
end