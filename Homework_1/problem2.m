sum = zeros(50000,1);
for n = 1:12
    sum = sum + rand(50000, 1);
end
histogram(sum)