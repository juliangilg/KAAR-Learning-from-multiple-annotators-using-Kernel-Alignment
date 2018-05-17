function Q = MACostFunc(params, model)

if length(params)~= model.sizew1
    error('The dimensions are not equal')
end


model.w1 = params;
pi = sigmoid1(model.X*model.w1');
Q = -sum(sum((model.mui.*(model.Y.*repmat(log(pi),1,model.R) +...
    (1-model.Y).*repmat(log((1-pi)),1,model.R)))));