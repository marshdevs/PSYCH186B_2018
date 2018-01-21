sum = zeros(50000,1);
for n = 1:12
    sum = sum + rand(50000, 1);
end
histogram(sum)
fprintf('mean: %12f, stdev: %12f', mean(sum), std(sum));