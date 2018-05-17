function g = MAGradFunc(params, model)

if length(params)~= model.sizew
    error('The dimensions are not equal')
end

model.w = params;
model.w1 = model.w(1:model.sizew1);
model.w2 = model.w(model.sizew1+1: model.sizew1+model.sizew2);
model.W1 = model.w1';
model.W2 = reshape(model.w2,model.D+1,model.R);

pi = sigmoid1(model.X*model.W1);

Gr1 = model.X'*(pi - model.mui);
nt  = sigmoid1(model.X*model.W2);
for j = 1:model.R
    aux = model.Y(:,j).*(2*model.mui-1) + (1-model.mui) - nt(:,j);
    Gr2(:,j) = -sum((repmat(aux,1,model.D+1).*model.X))';
end
% Gr2 = -model.X'*(((model.Y.^2 - repmat(model.mui,1,model.R).*(2*model.Y - 1))...
%         ./(2*sigma2.^2) - 1./(2*sigma2)).*sigma2.*(1-sigma2));
g = [Gr1(:)', Gr2(:)'];