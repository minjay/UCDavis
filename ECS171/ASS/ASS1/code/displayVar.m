function displayVar(x1,y1,x2,y2,name)
% This function is the connection function for question four. if will first
% generate five coefficients from order 0 to order 4, and then calculate
% the mse. At last, it will plot the information in the figure.
    coefficients = genCoefs(x1,y1);
    for n = 1:5
        mse(x1,y1,x2,y2,coefficients{n});
    end
    singlePolyPlot(x2,y2,coefficients,name);
end