function result = categorizeY(threshold,y)
% This function transforms the Y (dependent value) into two categories
% based on the threshold value given to the function.

% It creates a new array, and will evaluate the value based
% on the corresponding Y value.
    i = length(y);
    result = zeros(i,1);
    for n = 1:i
        if y(n) > threshold
            result(n) = 1;
        else
            result(n) = 0;
        end
    end
end