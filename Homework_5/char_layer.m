function output = char_layer( input )
% NAME LAYER
%
%
len = 10;
while len > length(input)
    input = [input, 0];
end

output = [];
if length(input) > len
    i = 1;
    while len > length(output)
        output = [output, input(i)];
        i = i + 1;
    end
else
    output = input;
end