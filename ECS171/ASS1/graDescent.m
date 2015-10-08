function result = graDescent(x,y,w,learnRate)
    [n,r] = size(x);
    z = dimExpand(x,1);
    keep = true;
    cost = 0;
    while keep
        temp = zeros(r+1,1);
        temp = temp + z' * (sigmoid(z,w) - y);
        w = w - learnRate * temp;
        cost_new = costFun(x,y,w);
        if abs(cost_new - cost) / cost <= 0.0001
            keep = false;
        end
        cost = cost_new;
    end
    result = w;
end