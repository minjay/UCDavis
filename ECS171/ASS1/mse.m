function result = mse(x1,y1,x2,y2,coefficient)
        [n1,r1] = size(x1);
		[n2,~] = size(x2);
        n = (length(coefficient)-1)/r1;
		z1 = dimExpand(x1,n);
		z2 = dimExpand(x2,n);
		mse1 = (transpose(y1 - z1 * coefficient)) * (y1 - z1 * coefficient)/(n1 - length(coefficient));
		mse2 = (transpose(y2 - z2 * coefficient)) * (y2 - z2 * coefficient)/(n2 - length(coefficient));
		fprintf('The Mean Square Error for order %d: train: %f, test: %f \n', n, mse1, mse2);
		result = [mse1, mse2];
end
