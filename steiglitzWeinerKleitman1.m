function [Kc, totalDist,...
          defi, permi] = steiglitzWeinerKleitman1(Dc, concentrador, ...
                                                    nodes, R,replicate)
%
%           STEIGLITZ-WEINER-KLEITMAN HEURISTIC
%
%           OUTPUT:
%               Kc := Main-nodes connection matrix
%        totalDist := total dsitance
%             defi := deficit vector (optional)
%            permi := permutation vector.
%
%            INPUT:
%               Dc := Main nodes' distance matrix
%     concentrador := boolean. Main-nodes' identifier
%            nodes := nodes' identifier
%                R := Redundancy factor
%        replicate := Times to run the heuristic.
%
%  version Incera
%
if nargin > 4
    rep = replicate;
else
    rep = 5;
end

maxiter = 100;

nodesC = nodes(concentrador==true);
n = length(nodesC);

finalM = zeros(n);
finalC = 0;
 
fprintf('\n| It  |  workC  |  finalC  |  :');
for i=1:rep
    Rnum = randi(10000, 1, 1);
    rng(Rnum,'twister');
    
    workM = zeros(n);
    workC = 0;
    
    indx = 1:n;
    permutation = randperm(n)';
    deficit = R.*ones(n,1); 

    iter = 1;
    
    while ~isempty(deficit(deficit>=0)) && iter < maxiter
        
        maxwh = max(deficit);
        wh = indx(deficit==maxwh);
        
        if length(wh)>1
            wh = indx(permutation==min(permutation(wh)));
        end
        
        maxwith = max(deficit(indx~=wh));
        with = indx(deficit==maxwith);
        with = with(with~=wh);
        
        if length(with)>1
            to_choose = Dc(wh,with);
            [minwith where] = min(to_choose);
            with = indx(Dc(wh,:)==minwith);
            
            if length(with)>1
                with = ...
                    indx(permutation==min(permutation(with)));
            end
            
            while workM(wh,with) > 0
                to_choose(where) =...
                    max(to_choose)*2;
                with = indx(deficit==maxwith);
                [minwith where] = min(to_choose);
                with = indx(Dc(wh,:)==minwith);
                
                if length(with)>1
                    with = indx(min(permutation(with)));
                end
            end
            
        end
        
        % Update deficit
        deficit(wh) = deficit(wh)-1;
        deficit(with) = deficit(with)-1;
        
        workM(wh,with) = Dc(wh,with);
        iter = iter +1;
    end
       
    if i==1
        finalC = sum(sum(workM));
        workC = finalC;
        finalM = workM;
    else
        workC = sum(sum(workM));
        if workC < finalC
            finalC = workC;
            finalM = workM;
        end
    end  
    fprintf('\n| %3d | %4.3f | %4.3f|', i, workC, finalC);
end

Kc = finalM;
totalDist = finalC;
if nargout > 2
    defi = deficit;
    if nargout > 3
        permi = permutation;
    end
end

        
