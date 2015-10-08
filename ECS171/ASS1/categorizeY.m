function result = categorizeY(threshold,y)
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