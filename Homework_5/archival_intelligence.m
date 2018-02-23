%%% Homework 5 - Archival Intelligence %%%
function data = archival_intelligence( input )

input = serialize_data(input, 1, 5);

%%% Name Layer %%%
input{1,1} = char_layer(input{1,1});

%%% Warp Drive Layer %%%
input{1,2} = num_layer(input{1,2});

%%% Hailing Transponder Layer %%%
input{1,3} = num_layer(input{1,3});

%%% Surface Reflect Layer %%%
input{1,4} = char_layer(input{1,4});

%%% Axis Ratio Layer %%%
input{1,5} = num_layer(input{1,5});

data = [];
for i = 1:5
    data = [data, input{1,i}];
end
