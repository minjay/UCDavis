function result = oddTransfer(x)
% This little function just compare the results with 0.5 threshold: if
% bigger, set to 1, otherwise, set to 0.
    [n,~] = size(x);
    result = zeros(n,1);
    for i = 1:n
        if x(i) > 0.5
            result(i) = 1;
        else
            result(i) = 0;
        end
    end
end