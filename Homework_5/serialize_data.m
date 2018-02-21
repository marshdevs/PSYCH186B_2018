function data = serialize_data( input, rows, columns )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

colors = {'Black', 'Dark Gray', 'Dark Blue', 'Dark Green', 'Blue', 'Light Blue', 'Light Gray', 'White', 'Pink', 'Orange', 'Yellow'};
color_values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

for i = 1:rows
    for j = 1:columns
        if isa(input{i,j}, 'char')
            if ~isempty(regexp(input{i,j}, '^_*$', 'once'))
                input{i,j} = -1;
            else
                index = find(ismember(colors ,input{i,j}));
                if ~isempty(index)
                    input{i, j} = color_values(index(1));
                elseif strcmp(input{i,j}, 'Light Color')
                    input{i,j} = 5.5;
                elseif strcmp(input{i,j}, 'Dark Color')
                    input{i,j} = 2;
                elseif strcmp(input{i,j}, 'Black or DK Blue')
                    input{i,j} = 1;
                else
                    input{i,j} = double(input{i,j});
                end
            end
        end
    end
end

data = input;