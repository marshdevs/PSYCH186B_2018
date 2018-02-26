function output = num_layer( input )
% MURDS LAYER
%
%

output = [];

char_input = num2str(input);

for i = 1:10
    if  i <= length(char_input)
        output = [output, char_input(i)];
    else
        output = [output, '0'];
    end
end
output = double(output);