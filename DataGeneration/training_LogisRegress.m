% Final Project.
% Master in electric engineering.


function [w, AUCTr] = training_LogisRegress(X, t)
% Seed for the random numbers generator
% s = RandStream.create('mt19937ar','seed',1e1);
% RandStream.setGlobalStream(s);
% 
D = size(X,2); % input space dimension
N = size(X,1); % number of samples.

X = [ones(N,1) X];

loglik1 = 0;
difloglik = 1;
w = inv(X'*X+ 1e-20*eye(D+1))*X'*t;
while difloglik > 1e-6
    y = sigmoid1(X*w);
    gr = X'*(y - t);
    H  = X'*diag((y.*(1-y)))*X;
    w  = w - (H + 1e-20*eye(D+1))\gr;
    loglik2 = -sum((t.*log(y) + (1-t).*log(1-y)));
    difloglik = abs(loglik2 - loglik1);
    loglik1 = loglik2;
end
[~, AUCTr, ~, ~] = PerMeasur(t, y);