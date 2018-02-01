%%% PROBLEM 3 %%%
dim = 1; % Tested also 1, 20, 40, 60, 80

% (1) Generate many pairs of normalized random vectors, fi and gi
f = [];
g = [];
for n = 1:dim
    fi = randn(1000, 1);
    gi = randn(1000, 1);
    finorm = fi / norm(fi);
    ginorm = gi / norm(gi);
    f(:,n) = finorm;
    g(:,n) = ginorm;
end

% (2) Compute the outer product matrices, ai = gifiT
% and
% (3) Form the overall connectivity matrix, A, as the sum of the individual
% outer product matrices, that is A = SUM(ai)
A = zeros(1000, 1000);
for n = 1:dim
    ft = transpose(f(:,n));
    ai = g(:,n) * ft;
    A = A + ai;
end

% (4) Test the resulting matrix:
%    a. Compute the output for each stored input fi
%    b. Compare it with what it should be
%    c. Compute the length of the output vector
gprime = [];
compare = [];
lengths = [];
for n = 1:dim
    giprime = A * f(:,n);
    gprime(:,n) = giprime;
    compare = [compare ; dot(gprime(:,n), g(:,n))];
    lengths = [lengths ; norm(giprime)];
end

%    d. Test the selectivity of the system
frand = [];
for n = 1:500
    frandi = randn(1000, 1);
    frandinorm = frandi / norm(frandi);
    frand(:,n) = frandinorm;
end

frandprime = [];
randlengths = [];
for n = 1:500
    frandprimei = A * frand(:,n);
    randlengths = [randlengths ; norm(frandprimei)];
end
fprintf('Avg output magnitude of a random input: %12f', mean(randlengths));
histogram(randlengths)
    
% (5) Repeat for different numbers of pairs of stored vectors

%  Repeated it for numpairs = {1, 20, 40, 60, 80, 100}
%   Numpairs: 1; Avg. output length: 0.019401
%   Numpairs: 20; Avg. output length: 0.134580
%   Numpairs: 40; Avg. output length: 0.200084
%   Numpairs: 60; Avg. output length: 0.245487
%   Numpairs: 80; Avg. output length: 0.280739
%   Numpairs: 100; Avg. output length: 0.312202
