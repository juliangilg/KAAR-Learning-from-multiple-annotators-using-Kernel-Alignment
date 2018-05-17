function Q = MACostFunc(params, model)

if length(params)~= model.sizew
    error('The dimensions are not equal')
end

model.w = params;
model.w1 = model.w(1:model.sizew1);
model.w2 = model.w(model.sizew1+1: model.sizew1+model.sizew2);
model.W1 = model.w1';
model.W2 = reshape(model.w2,model.D+1,model.R);

pi = sigmoid1(model.X*model.W1);
[ai, bi] = Compute_ab(model); 

Q = -sum(model.mui.*log((pi.*ai)) + (1-model.mui).*log(((1-pi).*bi)));