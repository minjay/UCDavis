function displayQFour(dataset,name)
% This is the display function for question four. It will call the function
% displayVar, which will be explained in that function. Its main job is to
% pass a loop and give the needed name value to the plot function.
    [~,n] = size(dataset);
    for i = 2:n
        fprintf('Now for variable %s \n',name{i});
        displayVar(dataset(1:280,i),dataset(1:280,1),dataset(281:392,i),dataset(281:392,1),name{i});
        fprintf('\n');
    end
end