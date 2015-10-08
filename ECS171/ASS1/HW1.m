% First I transform the data into csv file, and then read it into matlab:
d = readtable('~/desktop/auto-mpg.csv','delimiter',',');
%%%%% d.Properties.VariableNames = {'mpg','cylinders','displacement','horsepower','weight','acceleration','modelYear','origin','carName'};

% 1. For the first question, I first transform the table into an array, then calculate its 1/3 and 2/3 quantile:
quantile(table2array(d(:,1)),[1/3,2/3]);
% The result is 19.0000 and 26.9667 respectively. They are the threshold.

% 2. First we need to convert the table into matrix then use plotmatrix:

%%%%%%%%%%%% plotmatrix(table2array(d(:,1:8)));

% Here I can see the variables 'cylinders' and 'origin' are related to the three levels of mpg

% 3.

% 4.

d_mat = table2array(d(:,1:8));

mpg = d_mat(:,1);
cylinders = d_mat(:,2);
displacement = d_mat(:,3);
horsepower = d_mat(:,4);
weight = d_mat(:,5);
acceleration = d_mat(:,6);
modelYear = d_mat(:,7);
origin = d_mat(:,8);

%displayQFour(acceleration(1:280),mpg(1:280),acceleration(281:392),mpg(281:392))

% 5

%displayQFive(d_mat(1:280,2:8),mpg(1:280),d_mat(281:392,2:8),mpg(281:392));

% 6

%displayQSix(d_mat(1:280,2:8),mpg(1:280),d_mat(281:392,2:8),mpg(281:392),9,0.001);

% 7

test = [6,300,170,3600,9,80,1];
displayQSeven(d_mat(:,2:8),mpg,test);
