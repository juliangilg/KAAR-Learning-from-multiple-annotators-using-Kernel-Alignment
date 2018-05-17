function  [Acc, AUC, sensitivity, specificity] = PerMeasur(tte, predtest)

predict = round(predtest);
Acc = sum(predict == tte) / numel(predict);
sensitivity = sum(tte == 1 & predict == tte) / sum(tte == 1);
specificity = sum(tte == 0 & predict == tte) / sum(tte == 0);
AUC = -1;
[rocx,rocy,~,AUC] = perfcurve(tte,predtest,1);