function displayQSeven(x1,y1,x2)
    [~,r] = size(x1);
    polyCoef = singlePolyReg(x1,y1,2);
    polyY = yhat(x2,polyCoef);
    fprintf('The estimated MPG is %f under second order multivariate polynomial regression \n', polyY);
    fprintf('Based on the result above, the estimated MPG is medium under second order multivariate polynomial regression \n');
    threshold1 = 18.6667;
    threshold2 = 26.9667;
    learnRate = 0.001;
    z1 = categorizeY(threshold1,y1);
    z2 = categorizeY(threshold2,y1);
    w = rand(r+1,1);
    w1 = graDescent(x1,z1,w,learnRate);
    logisticY1 = yhatLogistic(x2,w1);
    w = rand(r+1,1);
    w2 = graDescent(x1,z2,w,learnRate);
    logisticY2 = yhatLogistic(x2,w2);
    if logisticY1 > 0.5
        fprintf('The estimated MPG is medium under medium compared to low based on logistic regression \n');
    else
        fprintf('The estimated MPG is low under medium compared to low based on logistic regression \n');
    end
    if logisticY2 > 0.5
        fprintf('The estimated MPG is high under high compared to medium based on logistic regression \n');
    else
        fprintf('The estimated MPG is medium under high compared to medium based on logistic regression \n');
    end
    fprintf('Based on the results above, the estimated MPG is medium under logistic regression \n');
end