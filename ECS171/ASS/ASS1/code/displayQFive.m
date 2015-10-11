function displayQFive(x1,y1,x2,y2)
% This is the display function to display the result of question five. It
% will first calculate the coefficient of multivariate regression of order
% 0 to 2, then call the mse function to calculate the train mse and test
% mse, and print the result to the screen.
    for i = 0:2
        q5Coef = singlePolyReg(x1,y1,i);
        mse(x1,y1,x2,y2,q5Coef);
        fprintf('\n');
    end
end