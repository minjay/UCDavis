function result = oddTransfer(x)
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