function result = mseLogistic(x1,y1,x2,y2,w)
    [n1,~] = size(x1);
    [n2,~] = size(x2);
    x1 = dimExpand(x1,1);
    x2 = dimExpand(x2,1);
    z1 = sigmoid(x1,w);
    z2 = sigmoid(x2,w);
    z1 = oddTransfer(z1);
    z2 = oddTransfer(z2);
    mse1 = sum(abs(y1 - z1))/n1;
    mse2 = sum(abs(y2 - z2))/n2;
    result = [mse1, mse2];
    fprintf('The Mean Square Error for logistic regression: train: %f, test: %f \n', mse1, mse2);
end