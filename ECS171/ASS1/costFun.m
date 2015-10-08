function result = costFun(x,y,w)
    result = 0;
    x = dimExpand(x,1);
    [n, ~] = size(x);
    for k = 1:n
        temp = sigmoid(x,w);
        if y(k) == 1
            result = result + log(temp);
        else
            result = result + log(1-temp);
        end
    end
end