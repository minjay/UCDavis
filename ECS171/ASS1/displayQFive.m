function displayQFive(x1,y1,x2,y2)
    q5Coef = singlePolyReg(x1,y1,2);
    mse(x1,y1,x2,y2,q5Coef);
end