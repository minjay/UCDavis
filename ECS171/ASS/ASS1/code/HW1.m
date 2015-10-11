% This is the main script for this assignment. This only serves as one
% job: call the display functions to show the results. The processes are
% defined in the little functions. More information can be seen on the
% report.

% Also, to learn more information about each display functions, please look
% at the bodies of the functions each or the report. Either of them
% decsribes what the function do and how it call functions in my logic. In
% one word, the display functions are just interfaces to make the main
% homework srcipt looks neat and readable.

% First I transform the data into csv file, and then read it into matlab:
d = readtable('/Users/Elliot/Github/UCDavis/ECS171/ASS/ASS1/data/auto-mpg.csv','delimiter',','); % Read data
d_name = {'mpg','cylinders','displacement','horsepower','weight','acceleration','modelYear','origin'}; % name for each column
d_mat = table2array(d(:,1:8)); % transform the table format to matrix format 
% Also I can set the names of columns from 2 to 8:
% mpg = d_mat(:,1);
% cylinders = d_mat(:,2);
% displacement = d_mat(:,3);
% horsepower = d_mat(:,4);
% weight = d_mat(:,5);
% acceleration = d_mat(:,6);
% modelYear = d_mat(:,7);
% origin = d_mat(:,8);

% 1. 
quant = quantile(table2array(d(:,1)),[1/3,2/3]);

% 2. 
%plotmatrix(d_mat(:,1:8));

% 3.
% Please see function dimExpand() and singlePolyReg().

% 4.
%displayQFour(d_mat,d_name);

% 5
displayQFive(d_mat(1:280,2:8),d_mat(1:280,1),d_mat(281:392,2:8),d_mat(281:392,1));

% 6
displayQSix(d_mat(1:280,2:8),d_mat(1:280,1),d_mat(281:392,2:8),d_mat(281:392,1),18.6667,0.000001);

% 7
test = [6,300,170,3600,9,80,1]; % creates the vector to be predicted
displayQSeven(d_mat(:,2:8),d_mat(:,1),test);