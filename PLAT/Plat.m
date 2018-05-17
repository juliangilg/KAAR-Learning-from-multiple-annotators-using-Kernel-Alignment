function [hatY] = Plat(L)


[N, R] = size(L); %number of samples in the training set.
Frepos = 0:1/R:1;
Nfre = length(Frepos);
Freq_Table = struct('Frepos', num2cell(Frepos),...
                    'Count', num2cell(zeros(1,Nfre)),...
                    'items', [], 'Cat', num2cell(zeros(1,Nfre)));
for i = 1:N
   fi = length(find(L(i,:)==1))/R;
   delta1 = fi-0.001;
   delta2 = fi+0.001;
   for j = 1:Nfre
       if Frepos(j) >= delta1 && Frepos(j) <= delta2
           idx = j;
       end
   end
   Freq_Table(idx).Count = Freq_Table(idx).Count + 1;
   Freq_Table(idx).items = [Freq_Table(idx).items, i];
end
[t, Nl, Nr] = EstimateTresholdP(Freq_Table, Nfre, N);
Pmax = (Nl - Nr)*Nr/(Nl + Nr) + Nr;
k = Nfre;
Np = 0;
while k>t
    Freq_Table(k).Cat = 1;
    Np = Np + Freq_Table(k).Count;
    k = k - 1;
end
fm = (Freq_Table(1).Frepos + Freq_Table(t).Frepos)*0.5;
k = t;
while Freq_Table(k).Frepos > fm && Np + Freq_Table(k).Count < Pmax
    Freq_Table(k).Cat = 1;
    Np = Np + Freq_Table(k).Count;
    k = k - 1;
end
hatY = zeros(N,1);
for i = 1:Nfre
    aux = Freq_Table(i).items;
    hatY(aux) = Freq_Table(i).Cat;
end
    
    