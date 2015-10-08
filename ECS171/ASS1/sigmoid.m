function result = sigmoid(x,w)
    result = 1 ./ (1 + exp(- x * w));
end