function [Kret] = esauWilliams(Dindx, Cindx, Nindx)
%
%        ESAU-WILLIAMS ALGORITHM
%
%           Dindx := distance Matrix for Cindx
%           Cindx := Node index
%           Nindx := Nodes to be connected
%
N = length(Nindx);
indx = find(Nindx == Cindx);
worked = zeros(N,1);

% Building the Difference Matrix
diffM = zeros(size(Dindx));
K = diffM; 
K(indx,:) = Dindx(indx,:);
K(:,indx) = Dindx(:,indx);

for i=1:N
    for j=1:N
        if i ~= j
            diffM(i,j) = Dindx(i,j) - Dindx(i,indx);
        end
    end
end

termine = false;


while ~termine
    [minCol Icol] = min(diffM);
    [~, Irow] = min(minCol);
    % min value for diffM is at (Icol(Irow), Irow)!!!
    
    if ~worked(Icol(Irow))
        
        K(Icol(Irow), Irow) = Dindx(Icol(Irow), Irow);
        K(Irow, Icol(Irow)) = Dindx(Icol(Irow), Irow);
        
        if Dindx(Icol(Irow), indx) <= Dindx(Irow, indx)
            K(indx,Irow) = 0;
            K(Irow,indx) = 0;
        else
            K(Icol(Irow), indx) = 0;
            K(indx, Icol(Irow)) = 0;
        end
        
    end
    
    diffM(Icol(Irow), Irow) = 0;
    diffM(Irow, Icol(Irow)) = 0;
    
    worked(Icol(Irow)) = true;
    
    termine = (min(min(diffM)) >= 0); 
end

Kret = K;
    

