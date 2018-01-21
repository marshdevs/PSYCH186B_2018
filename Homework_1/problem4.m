count = 0;
size = 500000;
for n = 1:size
    r = -1 + (1+1)*rand(2,1);
    if norm(r) <= 1
        count = count + 1;
    end
end

fprintf('pi = %.12f', (4 * count / size));