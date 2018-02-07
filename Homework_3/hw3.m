%%% Homework 3 %%%
pnums = 300;

f = [];
g = [];
for n = 1:pnums
    fi = randn(100, 1);
    gi = randn(100, 1);
    finorm = fi / norm(fi);
    ginorm = gi / norm(gi);
    f(:,n) = finorm;
    g(:,n) = ginorm;
end

A = zeros(100, 100);
for n = 1:pnums
    ft = transpose(f(:,n));
    ai = g(:,n) * ft;
    A = A + ai;
end
% Part C, simulate random chance
Arandom = A;

gprime = [];
compare = [];
lengths = [];
for n = 1:pnums
    giprime = A * f(:,n);
    gprime(:,n) = giprime;
    compare = [compare ; dot(gprime(:,n), g(:,n))];
    lengths = [lengths ; norm(giprime)];
end
% fprintf('avg cos: %12f, avg length: %12f\n', mean(compare), mean(lengths));

% add learning
learning_trials = pnums*10;

epsilon = 1/1000;

trials = [];
errors = [];
percent_diffs = [];
percent_diff_mean_diffs = [];
for i = 1:learning_trials
    vi = floor(rand*pnums) + 1; % between 0 - pnums
    % Part D, consecutive inputs 
    % vi = mod(i, pnums) + 1;
    ki = 1/(f(:,vi)' * f(:,vi)) - epsilon;
    gprime = A * f(:,vi);
    deltaA = ki*(g(:,vi) - gprime)*f(:,vi)';
    A = A + deltaA;
    
    % evaluate performance
    error = g(:,vi) - gprime;
    error = error.^2;
    errors = [errors ; norm(error)];
    
    % Part B, measuring convergence
%     mean_pre_diff = mean(percent_diffs);
%     percent_diff = abs((errors(i) - mean(errors))/mean(errors));
%     percent_diffs = [percent_diffs; percent_diff];
%     mean_post_diff = mean(percent_diffs);
%     percent_diff_mean_diffs = [percent_diff_mean_diffs ; (mean_post_diff - mean_pre_diff)/mean_pre_diff];
    
    trials = [trials ; i];
    % the more trials you learn, the smaller error should become
end

% Part C, simulate random chance
% random_errors = [];
% random_trials = [];
% for i= 1:learning_trials
%     vi = floor(rand*pnums) + 1;
%     ki = 1/(f(:,vi)' * f(:,vi)) - epsilon;
%     vi2 = floor(rand*pnums) + 1;
%     gprime = g(:,vi2);
%     deltaArandom = ki*(g(:,vi) - gprime)*f(:,vi)';
%     Arandom = Arandom + deltaArandom;
%     
%     % evaluate performance
%     error = g(:,vi) - gprime;
%     error = error.^2;
%     random_errors = [random_errors ; norm(error)];
%     random_trials = [random_trials ; i];
% end

% percent_diffs = [];
% for i = 1:length(errors)
%     percent_diff = abs((errors(i) - mean(errors))/mean(errors));
%     fprintf('diff: %12f\n', percent_diff);
%     percent_diffs = [percent_diffs; percent_diff];
% end

% Part A, measuring oscillation
% Part D
plot(trials, errors);

% Part B, measuring convergence
% plot(trials, percent_diff_mean_diffs)

% Part C, simulate random chance
% figure
% plot(random_trials, random_errors, trials, errors)