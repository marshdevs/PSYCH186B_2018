%%% PROBLEM 1 %%%

% Insert linear associator code

pnums = 5000; % Tested also 1, 20, 40, 60, 80, 100

f = [];
g = [];
for n = 1:pnums
    fi = randn(1000, 1);
    gi = randn(1000, 1);
    finorm = fi / norm(fi);
    ginorm = gi / norm(gi);
    f(:,n) = finorm;
    g(:,n) = ginorm;
end

A = zeros(1000, 1000);
for n = 1:pnums
    ft = transpose(f(:,n));
    ai = g(:,n) * ft;
    A = A + ai;
end

gprime = [];
compare = [];
lengths = [];
for n = 1:pnums
    giprime = A * f(:,n);
    gprime(:,n) = giprime;
    compare = [compare ; dot(gprime(:,n), g(:,n))];
    lengths = [lengths ; norm(giprime)];
end
fprintf('avg cos: %12f, avg length: %12f\n', mean(compare), mean(lengths));

% add learning
learning_trials = pnums*10;

epsilon = 1/1000;

trials = [];
errors = [];
for i = 1:learning_trials
    vi = floor(rand*pnums) + 1; % between 0 - pnums
    %vi = mod(i, pnums) + 1;
    ki = 1/(f(:,vi)' * f(:,vi)) - epsilon;
    gprime = A * f(:,vi);
    deltaA = ki*(g(:,vi) - gprime)*f(:,vi)';
    A = A + deltaA;
    
    % evaluate performance
    error = g(:,vi) - gprime;
    error = error.^2;
    errors = [errors ; mean(error)];
    trials = [trials ; i];
    % the more trials you learn, the smaller error should become
end

plot(trials, errors);