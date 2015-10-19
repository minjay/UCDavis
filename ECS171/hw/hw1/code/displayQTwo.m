function displayQTwo(matrix)
% This is the display function for question2. It accepts a matrix as input,
% and then categorize the first column as three levels, then draw the plot
% as pairs between any two columns.
    [n,~] = size(matrix);
    quants = quantile(matrix(:,1),[1/3,2/3]);
    for i = 1:n
        if matrix(i) < quants(1)
            matrix(i) = 0;
        elseif matrix(i) > quants(1) && matrix(i) < quants(2)
            matrix(i) = 1;
        else
            matrix(i) = 2;
        end
    end
    plotmatrix(matrix);
end