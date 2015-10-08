function displayQSix(x1,y1,x2,y2,threshold,learnRate)
    [~,r] = size(x1);
    y1 = categorizeY(threshold,y1);
    w = rand(r+1,1);
    w = graDescent(x1,y1,w,learnRate);
    mseLogistic(x1,y1,x2,y2,w);
end