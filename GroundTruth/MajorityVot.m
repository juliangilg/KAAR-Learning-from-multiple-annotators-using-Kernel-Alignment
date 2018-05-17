function Ytr_mv = MajorityVot(Y)
Y = round(Y);
Ytr_mv = [];
R = size(Y,2);
for n = 1:size(Y,1)
    votes = zeros(2,1);
    for r = 1:R
        if Y(n,r) == 0
            votes(1) = votes(1) + 1;
        elseif Y(n,r) == 1
            votes(2) = votes(2) + 1;
        end
    end
    [m,pos] = max(votes);
    mv = 0;
    if pos == 2
        mv = 1;
    end
    Ytr_mv = [Ytr_mv; mv];
end