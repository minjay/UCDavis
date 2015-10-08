function coefficient = singlePolyReg(x,y,order)
	z = dimExpand(x,order);
	coefficient = (transpose(z) * z) \ (transpose(z) * y);
end