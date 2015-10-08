function displayQFour(x1,y1,x2,y2)
    coefficients = genCoefs(x1,y1);
    for n = 1:5
        mse(x1,y1,x2,y2,coefficients{n});
    end
    singlePolyPlot(x2,y2,coefficients);
end