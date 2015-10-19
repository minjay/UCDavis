function coefficient = singlePolyReg(x,y,order)
% This function implements the algorithm for polynomial regression.
	z = dimExpand(x,order);
	coefficient = (transpose(z) * z) \ (transpose(z) * y);
end