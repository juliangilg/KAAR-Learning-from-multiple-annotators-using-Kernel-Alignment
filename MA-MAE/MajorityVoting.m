% calculate majority voting

function mu = MajorityVoting(Y,K)

Y = Y+1;
R = size(Y, 2); 
N = size(Y, 1);

% mayority voting to estimate the true label.
mu_ic1 = zeros(N, K);
for i=1:K
    tempo = zeros(nTrain, R);
    tempo(aux1==i) = 1;
    mu_ic1(:,i) = sum(tempo,2)/R;     
end

mu_ic2 = round(mu_ic1);
index11 = find(sum(mu_ic2, 2)<1);
index12 = find(sum(mu_ic2, 2)>1);

if ~isempty(index11)
    mu_ic2(index11, :) = mnrnd(1, ones(length(index11), K)/K);
end

if ~isempty(index12)
    mu_ic2(index12, :) = mnrnd(1, ones(length(index12), K)/K);
end        

[~, mu_ic] = max(mu_ic2');
mu_ic = mu_ic';
t_MV{tj1} = mu_ic;




end

save('voice_features.mat', 't_MV', '-append')