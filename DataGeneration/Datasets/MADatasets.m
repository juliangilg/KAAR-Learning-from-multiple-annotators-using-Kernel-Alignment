clc; close all; clear all;

% We fix the seed for the random numbers generator
s = RandStream.create('mt19937ar','seed',1e1);
RandStream.setGlobalStream(s);

% We load the Datasets
% name     = 'breast-cancer-wisconsin';
% name     = 'bupa';
% name     = 'ionosphere';
% name     = 'parkinsons';
% name     = 'pima-indians-diabetes';
% name     = 'tic-tac-toe';
% name     = 'haberman';
% name     = 'vertebral';
name     = 'SPECT';


filename = strcat(name, '.data.txt');
if strcmp(name, 'parkinsons') == 1
    D = csvread(filename, 1, 1);
elseif strcmp(name, 'breast-cancer-wisconsin')
    D = csvread(filename,0,1);
    aux = find((sum(D,2)) < 0);
    D(aux,:) = [];
else
    D = csvread(filename);
end

if strcmp(name, 'parkinsons') == 1
    X = D;
    X(:,end-6) = [];
    t = D(:,end-6);
elseif strcmp(name, 'SPECT') == 1
    X = D(:,2:end);
    t = D(:,1);
else
    X = D(:,1:end-1); % features
    t = D(:,end); % Gold standard
end
[t, I] = sort(t);
X = X(I,:);
auxt = sum(unique(t));
switch auxt
    case 6
        t(t == 2) = 0;
        t(t == 4) = 1;
    case 3
        t = t-1;
end

R = 5; % Número de anotadores
alpha = [0.9 0.8 0.7 0.6 0.2]; % Se escogen uniformemente las sensitivities para cada anotador
beta =  [0.9 0.8 0.7 0.6 0.2]; % Se escogen uniformemente las especificities para cada anotador

Y = zeros(size(X,1), R);

% Genera las etiquetas de acuerdo a cada anotador
for r = 1:R
    alphar = binornd(1, alpha(r), 1, length(find(t == 0)))';
    Y(t == 0, r) = t(t == 0);
    Y(alphar == 0, r)  = 1;
    betar = binornd(1, beta(r), 1, length(find(t == 1)))';
    Y(t == 1, r) = t(t == 1);
    indexu = find(betar == 0); 
    Y(indexu + length(find(t == 0)), r)  = 0;
end
savefile = strcat('../', name, '.mat');
save(savefile, 'X', 'Y', 't')