% multiple annotators generation. 
% Julian Gil Gonzalez, PhD student, 2017.
% Grupo de investigación en automática.

clc; close all; clear all;

% We fix the seed for the random numbers generator
s = RandStream.create('mt19937ar','seed',1e2);
RandStream.setGlobalStream(s);

for b = 1:9
    % We load the Datasets
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

% Se preprocesan las bases de datos con el fin de garantizar que todas las
% etiquetas sean 0 o 1
name1 = strcat('Datasets/', name);
filename = strcat(name1, '.data.txt');
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
elseif strcmp(name1, 'SPECT') == 1
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


% % Con el fin de simular las etiquetas de forma sintética, se usan dos
% metodologías. La primera de ellas consiste en entrenar un clasificador
% basado en regresión logística, donde se usn las etiquetas verdaderas.
% Los pesos entrenados w, son normalizados y se les añade ruido Gaussiano
% con media cero y varianza sigma^2; luego, estos pesos corruptos son 
% "desnormalizados" y se clasifican todos lo datos usando estos pesos, el
% hecho de que los pesos sean corruptos por ruido genera que algunas
% muestras sean clasificadas de forma errónea. 

%% Entrenamiento del clasificador basado en regresión logística
sigma1 = ([-5 -10 -20 -30 -50]);
R = length(sigma1); % número de anotadores.
X1 = zscore(X);
[W, AUCTr] = training_LogisRegress(X1, t);
D = size(X,2); % input space dimension
N = size(X,1); % number of samples.
Xtilde = [ones(N,1) X1];
% se normalizan los pesos w con el fin de añadirles ruido Gaussiano
% auxw = sum(W);
W1 = W/sum(W);
Y = zeros(N, R);
for r=1:R
    sigmaL = (10^(-sigma1(r)/10))^2;
    aux = awgn(Xtilde*W, sigma1(r));
    Y(:,r) = sigmoid1(aux);
    [Acc(r), AUC(r), sensitivity(r), specificity(r)] = PerMeasur(t, Y(:,r));
end
MAData.X = X;
MAData.t = t;
MAData.Y = round(Y);
MAData.PerAnn1 = [Acc; AUC; sensitivity; specificity];

%% Generación de etiquetas con el modelo de la moenda sesgada
pflip = [0.1, 0.3, 0.5, 0.6, 0.7];
Y1 = zeros(N,R);
for r = 1:R
    aux = binornd(1, pflip(r), N, 1);
    index = find(aux==1);
    Y1(:,r) = t;
    Y1(index,r) = ~t(index);
    [Acc1(r), AUC1(r), sensitivity1(r), specificity1(r)] = PerMeasur(t, Y1(:,r));
end
MAData.Y1 = Y1;
MAData.PerAnn2 = [Acc1; AUC1; sensitivity1; specificity1];


%% Generación de etiquetas con el modelo de las dos moendas sesgadas
alpha = [0.9 0.9 0.8 0.4 0.3]; % Se escogen uniformemente las sensitivities para cada anotador
beta =  [0.8 0.9 0.9 0.4 0.5]; % Se escogen uniformemente las especificities para cada anotador

Y2 = zeros(size(X,1), R);

% Genera las etiquetas de acuerdo a cada anotador
for r = 1:R
    alphar = binornd(1, alpha(r), 1, length(find(t == 0)))';
    Y2(t == 0, r) = t(t == 0);
    Y2(alphar == 0, r)  = 1;
    betar = binornd(1, beta(r), 1, length(find(t == 1)))';
    Y2(t == 1, r) = t(t == 1);
    indexu = find(betar == 0); 
    Y2(indexu + length(find(t == 0)), r)  = 0;
    [Acc2(r), AUC2(r), sensitivity2(r), specificity2(r)] = PerMeasur(t, Y2(:,r));
end
MAData.Y2 = Y2;
MAData.PerAnn3 = [Acc2; AUC2; sensitivity2; specificity2];

savefile = strcat('MADatasets/', name, '.mat');
save(savefile, 'MAData')
end