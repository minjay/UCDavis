function result = costFun(x,y,w)
% This function calculates the cost function related to the logistic
% regression. The definition of cost function is well known, so I will not
% explain it here.
    result = 0;
    x = dimExpand(x,1);
    [n, ~] = size(x);
    for k = 1:n
        temp = sigmoid(x,w);
        if y(k) == 1
            result = result - log(temp);
        else
            result = result - log(1-temp);
        end
    end
end