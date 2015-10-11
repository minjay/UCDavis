function result = sigmoid(x,w)
% This is the sigmoid function designed for logistic regression.
    result = 1 ./ (1 + exp(- x * w));
end