function [t, Nl, Nr] = EstimateTresholdP(Freq_Table, Nfre, N)

maximaset = [];
maximaset(1) = 1;
minimaset = [];
minimaset(1) = 1;
for i=2:Nfre-1
    a = Freq_Table(i).Count - Freq_Table(i-1).Count;
    b = Freq_Table(i+1).Count - Freq_Table(i).Count;
    if a >=0 && b<=0 && diff1(Freq_Table(i).Frepos, Freq_Table(minimaset(end)).Frepos, Nfre, N)
        maximaset = [maximaset, i];
    end
    if a <=0 && b>=0 && diff1(Freq_Table(maximaset(end)).Frepos,Freq_Table(i).Frepos, Nfre, N)
        minimaset = [minimaset, i];
    end
end
% if Freq_Table(end).Frepos > Freq_Table(end-1).Frepos
%     maximaset = [maximaset, Nfre];
% end
    
minimaset(1) = [];
aux = zeros(1,length(maximaset));
for i = 1:length(maximaset)
    if Freq_Table(maximaset(i)).Frepos < 0.5
        aux(i) = Freq_Table(maximaset(i)).Count;
    else 
        aux(i) = 0;
    end
end
if sum(aux) == 0
    P1 =[];
else
    [~, amax] = max(aux);
    P1 = maximaset(amax);
    fP1 = Freq_Table(P1).Frepos;
end
aux1 = zeros(1,length(maximaset));
for i = 1:length(maximaset)
    if Freq_Table(maximaset(i)).Frepos > fP1
        aux1(i) = Freq_Table(maximaset(i)).Count;
    else 
        aux1(i) = 0;
    end
end
if sum(aux1) == 0
    P2 =[];
else
    [~, amax] = max(aux1);
    P2 = maximaset(amax);
    fP2 = Freq_Table(P2).Frepos;
end
if ~isempty(P1) && ~isempty(P2)
    if isempty(minimaset)
        valley = [];
    else
        aux2 = zeros(1,length(minimaset));
        for i = 1:length(minimaset)
            if Freq_Table(minimaset(i)).Frepos > fP1 &&...
               Freq_Table(minimaset(i)).Frepos < fP2
                aux2(i) = Freq_Table(minimaset(i)).Count;
            else 
                aux2(i) = 0;
            end
        end
        if sum(aux2) == 0
            valley =[];
        else
            [~, amin] = min(aux2);
            valley = minimaset(amin);
            fvalley = Freq_Table(valley).Frepos;
        end
    end
else
    valley = [];
end

if isempty(valley)
    t = P1;
else
    t = valley;
end
Nl = 0;
for i = 1:t
    Nl = Nl + Freq_Table(i).Count;
end
while Nl < N/2
    t = t + 1;
    Nl = Nl + Freq_Table(t).Count;
end
Nr = N - Nl;

end

