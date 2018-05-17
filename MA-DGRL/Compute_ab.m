function [ai, bi] = Compute_ab(model)

model.w1 = model.w(1:model.sizew1);
model.w2 = model.w(model.sizew1+1: model.sizew1+model.sizew2);
model.W1 = model.w1';
model.W2 = reshape(model.w2,model.D+1,model.R);
aux = sigmoid1(model.X*model.W2);
ai = (1-aux).^(abs((model.Y-1))).*aux.^(1-abs((model.Y-1)));
ai = prod(ai,2);
bi = (1-aux).^(abs((model.Y-0))).*aux.^(1-abs((model.Y-0)));
bi = prod(bi,2);