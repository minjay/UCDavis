function displayQSix(x1,y1,x2,y2,threshold,learnRate)
% This is the display function for question six. It will first transform y
% into categorical variable, and then generate a random weight vector, and
% after that pass all values to the gradient function graDescent(). At
% last, it will calculate the mse for logistic regression.
    [~,r] = size(x1);
    y1 = categorizeY(threshold,y1);
    y2 = categorizeY(threshold,y2);
    w = rand(r+1,1);
    w = graDescent(x1,y1,w,learnRate);
    mseLogistic(x1,y1,x2,y2,w);
    fprintf('\n');
end