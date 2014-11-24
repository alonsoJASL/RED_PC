function [nodos concentrador v freqs] = dysartGeorganas(k, nodes,...
                                                 distanceMatrix)
%           ALGORITMO DYSART-GEORGANAS
% Realiza el algoritmo de Dysart-Georganas de K conexiones. 
%
[freqs] = tablaVecindades(k, nodes, distanceMatrix);

N = length(nodes);
M = max(freqs);
J = [(1:M)' zeros(M,1)];

concentrador = zeros(N,1);

for i=1:M
    Sj = length(find(freqs==i));
    if Sj > 0
        J(i,2) = Sj;
    end
end

v = floor((J(:,1)'*J(:,2))/sum(J(:,2)))+1;

concentrador(find(freqs>=v)) = true;
nodos = nodes;

end

function [freqs] = tablaVecindades(k, nodes, distanceMatrix)
%                   TABLA DE VECINDADES
% Calcula la tabla de vecindades del algoritmo Dysart-Georganas
%
M = length(nodes);
freqs = zeros(M,1);

[vec I] = sort(distanceMatrix);
indx = I(1:k+1,:)';

for i=1:M
    freqs(i) = length(find(indx==i));
end

end