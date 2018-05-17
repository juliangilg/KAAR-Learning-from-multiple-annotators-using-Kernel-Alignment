function [aux] = diff1(l, s, Nfre, N)

epsilon = (0.03*N)/Nfre;
aux = l-s < epsilon ;


end

