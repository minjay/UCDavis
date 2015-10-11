function singlePolyPlot(x,y,coefficients,name)
% This is the plot for each variable. It will first draw points based on
% the original dataset, and then draws five lines on the same plot based on
% order 0 to order 4 coefficients.
  figure;
  z = transpose(min(x):0.01:max(x));
  y1 = yhat(z,cell2mat(coefficients(1)));
  y2 = yhat(z,cell2mat(coefficients(2)));
  y3 = yhat(z,cell2mat(coefficients(3)));
  y4 = yhat(z,cell2mat(coefficients(4)));
  y5 = yhat(z,cell2mat(coefficients(5)));
  plot(x,y,'bo');
  xlabel(name);
  ylabel('mpg');
  hold all;
  plot(z,y1);
  plot(z,y2);
  plot(z,y3);
  plot(z,y4);
  plot(z,y5);
  print(name,'-dpng');
end
