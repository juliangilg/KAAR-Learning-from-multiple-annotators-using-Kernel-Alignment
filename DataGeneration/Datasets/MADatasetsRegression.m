clc; close all; clear all;

% We fix the seed for the random numbers generator
s = RandStream.create('mt19937ar','seed',1e1);
RandStream.setGlobalStream(s);

% We load the Datasets
name     = 'housing';



filename = strcat(name, '.data.txt');
D = csvread(filename);
X = D(:,1:end-1);
t = D(:,end);

% We simulate three annotattors with different level of expertise
R = 3; % number of annotators
Annvar = [0.25, 0.5, 0.75];
Y = zeros(size(X,1), R);

% Genera las etiquetas de acuerdo a cada anotador
for r = 1:R
    Y(:,r) = t + sqrt(Annvar(r))*randn(length(t),1);
end
savefile = strcat('../', name, '.mat');
save(savefile, 'X', 'Y', 't')