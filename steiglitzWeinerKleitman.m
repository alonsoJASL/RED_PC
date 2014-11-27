function [Kc] = steiglitzWeinerKleitman(Dc, concentrador, nodes, R, ...
                                        replicate)
%
%           STEIGLITZ-WEINER-KLEITMAN HEURISTIC
%
%           OUTPUT:
%               Kc := Main-nodes connection matrix
%            INPUT:
%               Dc := Main nodes' distance matrix
%     concentrador := boolean. Main-nodes' identifier
%            nodes := nodes' identifier
%                R := Redundancy factor
%
%  version Incera
%

if nargin > 4
    rep = replicate;
else
    rep = 3;
end

nodesC = nodes(concentrador==true);
n = length(nodesC);

permutation = randperm(n);
DC = Dc(permutation,permutation);

deficit = R.*ones(n,1);



Kc = 0;