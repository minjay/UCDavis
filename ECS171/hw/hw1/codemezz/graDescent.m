function result = graDescent(x,y,w,learnRate)
% This is the core function for gradient descent and use it to do logistic
% regression. It main logic is, keep looping, until the error rate is less
% than 0.0001. While looping, it will update the weight vector in all
% dimensions simultaneously, based on the gradient descent algorithm. Then
% at last, return the weight vector.
    [~,r] = size(x);
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