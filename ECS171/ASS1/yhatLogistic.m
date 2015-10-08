function result = yhatLogistic(x,w)
    [n,~] = size(x);
    x = dimExpand(x,n);
    value = sigmoid(x,w);
    result = oddTransfer(value);
end