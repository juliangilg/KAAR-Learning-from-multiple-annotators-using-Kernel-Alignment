% Learning from multiple annotators: estimating the annotators performance
% in the feature space.

% Julian gil gonzalez
% PhD student, Engineering PhD program.
% Automatic research group

clc; close all; clear all;
% Add the toolboxes for the optimization step 
addpath(genpath('../GPs'))


% Seed for the random numbers generator
s = RandStream.create('mt19937ar','seed',1e2);
RandStream.setGlobalStream(s);

for b=6:9

    switch b
        case 1
            name     = 'breast-cancer-wisconsin';
        case 2
            name     = 'bupa';
        case 3
            name     = 'ionosphere';
        case 4
            name     = 'parkinsons';
        case 5
            name     = 'pima-indians-diabetes';
        case 6
            name     = 'tic-tac-toe';
        case 7
            name     = 'haberman';
        case 8
            name     = 'vertebral';
        case 9
            name     = 'SPECT';
    end

    % Loading the dataset
    cufold = pwd;
    cd('../DataGeneration/MADatasets/')
    load(name);
    cd(cufold)

    % In order to measure the performance for the model proposed we use a hold-out
    % validation scheme using the 70% of the data for training and 30% for the
    % test.
    X = MAData.X;
    Y = MAData.Y;
    t = MAData.t;

    R = size(Y,2); % number of annotators.
    D = size(X,2); % input space dimension
    N = size(X,1); % number of samples in the dataset.
    N1 = length(find(t==0)); % number of samples belonging to the class 0
    N2 = N - N1; % number of samples belonging to the class 1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % configurate de GP model for classification
       Ncg = 300; cov = {@covSEard}; sf = 1; ell = 0.7*ones(1, size(X,2));  % setup the GP
       hyp0.cov  = log([ell,sf]); mean1 = {@meanZero}; 
       hyp0.mean = [];
       lik = 'likLogistic'; 
       sn = 0.2;
       hyp0.lik = [];
       inf = 'infLaplace';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:30
        idx1 = randperm(N1); idx2 = N1 + randperm(N2);
        Xtr1 = X(idx1(1:round(N1*0.7)),:); Xte1 = X(idx1(round(N1*0.7)+1:N1),:);
        Xtr2 = X(idx2(1:round(N2*0.7)),:); Xte2 = X(idx2(round(N2*0.7)+1:N2),:);
        Xtr  = [Xtr1;Xtr2];
        Xte  = [Xte1;Xte2];
        Ytr1 = Y(idx1(1:round(N1*0.7)),:); Yte1 = Y(idx1(round(N1*0.7)+1:N1),:);
        Ytr2 = Y(idx2(1:round(N2*0.7)),:); Yte2 = Y(idx2(round(N2*0.7)+1:N2),:);
        Ytr  = [Ytr1;Ytr2];
        Yte  = [Yte1;Yte2];
        ttr1 = t(idx1(1:round(N1*0.7))); tte1 = t(idx1(round(N1*0.7)+1:N1));
        ttr2 = t(idx2(1:round(N2*0.7))); tte2 = t(idx2(round(N2*0.7)+1:N2));
        ttr  = [ttr1;ttr2];
        tte  = [tte1;tte2];
        % We normalize the input space
        [Xtr, mux, stdx] = zscore(Xtr);
        stdx(stdx ==0)=1;
        Nte = size(Xte,1);
        Xte = (Xte - repmat(mux,Nte,1))./repmat(stdx,Nte,1);
        % We estimate the annotators performance by means of Centered kernel
        % Alignment
        Ymv = Plat(Ytr);
        Ymv(Ymv == 0) = -1;
        hyp = minimize(hyp0,'gp', -Ncg, inf, mean1, cov, lik, Xtr, Ymv);
        [~, ~, ~, ~, aux] = gp(hyp, inf, mean1, cov, lik, Xtr,...
                                    Ymv, Xte, ones(length(tte), 1));
        predtest = exp(aux);
        % Performance evaluation
        [Acc(i), AUC(i), sensi(i), speci(i)] = PerMeasur(tte, predtest);
    end
    fileSave = strcat('ResultsPLAT/', name);
    save(fileSave, 'Acc', 'AUC')
end