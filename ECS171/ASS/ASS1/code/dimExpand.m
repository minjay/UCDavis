function matrix = dimExpand(x,order)
% This is one of the core function in regression. Indeed, what this
% function does is transform the X (independent value) to the desired
% matrix we need to do the regression based on the order. For example, with
% order 0, it will give a vector with ones; with order 1, it will append
% the X itself append to order 0, and so on so forth for higher orders.

% To note, this function has been optimized for matrix calculation, which
% means you can give either an array or a matrix as the input of X.
	t1 = 0;
	t2 = order;
	[r,n] = size(x);
	z = ones(r, 1 + n * order);
	while t2 > 0;
		t1 = t1 + n;
		z(:,t1-n+2:t1+1) = x.^(t1/n);
		t2 = t2 - 1;
	end
	matrix = z;
end
