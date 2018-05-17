function g = MAGradFunc(params, model)

if length(params)~= model.sizew1
    error('The dimensions are not equal')
end

model.w1 = params;
pi = repmat(sigmoid1(model.X*model.w1'), 1, model.R);
Gr = -sum((model.X'*(model.mui.*model.Y - pi.*model.mui)),2);

g = Gr';