function mu = CenteredAligment(X, Y, hyp)


% Now, we compute the function kernel over each one of the annotations
R = size(Y, 2); % number of annotators
KYYc = cell(R,1);

% kerf = @covSEiso; % We choose a squared exponetntial for the kernel function
% if nargin < 3
%     hyp = [log(1); log(1)];
% end
% KXX  = kerf(hyp, X); 

KXX = X*X';

% For the annotations, we use the 1-of-K codificaction 
N = size(X,1);
K = length(unique(Y));
aux1 = cell(R,1);
for r = 1:R
    aux = zeros(N,K);
    for k = 1:K
        idx = find(Y(:,r) == k);
        aux(idx, k) = 1;
    end
    aux1{r} = aux;
end
Y = aux1;
% We center the kernel function
m = size(X,1); 
Mones = ones(m,1);
KXXc = (eye(m) - Mones*Mones'/m)*KXX*(eye(m) - Mones*Mones'/m);
a = zeros(R,1);
for r = 1:R
%     KYYc{r} = (eye(m) - Mones*Mones'/m)*kerf(hyp, Y(:,r))*...
%               (eye(m) - Mones*Mones'/m);
    KYYc{r} = (eye(m) - Mones*Mones'/m)*(Y{r}*Y{r}')*...
              (eye(m) - Mones*Mones'/m);
    KYY{r} = (Y{r}*Y{r}');
%     KYYc{r} = (eye(m) - Mones*Mones'/m)*(covDel(Y{r}))*...
%               (eye(m) - Mones*Mones'/m);
    a(r) = FrobeniusProduct(KYYc{r}, KXXc);
end

% Then, we compute the weights \mu in order to estimate the outputs y as a
% linear combination of the annotations
P = R;
M = zeros(P);
for l = 1:P
    for k = 1:P
        M(k,l) = FrobeniusProduct(KYYc{k}, KYYc{l});
    end
end

% In order to compute mu, we solve a quadratic progaming problem
H = 2*M;
f = -2*a;
v = quadprog(H,f,[],[],[],[],zeros(R,1),[]);
mu = v/norm(v);

% mu = (M\a)/norm((M\a));


