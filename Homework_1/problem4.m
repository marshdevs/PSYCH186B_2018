count = 0;
for n =1:200000
    r = -1 + (1+1)*rand(2,1);
    if norm(r) <= 1
        count = count + 1;
    end
end

fprintf('pi = %d', (4 * count / 200000));