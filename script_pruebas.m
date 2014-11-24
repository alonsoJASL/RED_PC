% script de pruebitas
%

%% dysart-1
clear all
clc

nodos = (1:10)';
freqs = [1 5 3 6 6 5 5 4 2 3]';

N = length(nodos);
M = max(freqs);
J = [(1:M)' zeros(M,1)];

mybool = zeros(N,1);

for i=1:M
    Sj = length(find(freqs==i));
    if Sj > 0
        J(i,2) = Sj;
    end
end

v = floor((J(:,1)'*J(:,2))/sum(J(:,2)))+1;

mybool(freqs>=v) = true;

%% Prueba de tabla de vecindades
clear all
clc

distanceMatrix = ...
    [0 3 5 4 3 4 7 8 13 11
    3 0 2 2 1 2 5 5 9 9
    5 2 0 2 2 3 6 5 9 11
    4 2 2 0 1 2 5 3 7 9
    3 1 2 1 0 1 4 4 8 8 
    4 2 3 2 1 0 3 3 7 7 
    7 5 6 5 4 3 0 1 5 4
    8 5 5 3 4 3 1 0 4 6
    13 9 9 7 8 7 5 4 0 2
    11 9 11 9 8 7 4 6 2 0];
nodos = (1:10)';
k = 3;

M = length(nodos);
freqs = zeros(M,1);

[vec I] = sort(distanceMatrix);
indx = I(1:k+1,:)';

for i=1:M
    freqs(i) = length(find(indx==i));
end

%% Prueba Dysart-Georganas

clear all
clc

k =3;
nodos = (1:10)';
distanceMatrix = ...
    [0 3 5 4 3 4 7 8 13 11
    3 0 2 2 1 2 5 5 9 9
    5 2 0 2 2 3 6 5 9 11
    4 2 2 0 1 2 5 3 7 9
    3 1 2 1 0 1 4 4 8 8 
    4 2 3 2 1 0 3 3 7 7 
    7 5 6 5 4 3 0 1 5 4
    8 5 5 3 4 3 1 0 4 6
    13 9 9 7 8 7 5 4 0 2
    11 9 11 9 8 7 4 6 2 0];

[nodos concentrador v freqs] = dysartGeorganas(k, nodos,...
                                         distanceMatrix);
                                     
% escocger concentrador: Cindx
% construir matriz para dicho concentrador: Dindx

%% Prueba Esau-W 1

clear all
close all
clc

D = [0 2 52 13 45 15 58 59
    2 0 52 14 43 16 58 62
    52 52 0 60 85 41 23 55
    13 14 60 0 50 18 72 50
    45 43 85 50 0 59 81 95
    15 16 41 18 59 0 55 42
    58 58 23 72 81 55 0 78
    59 62 55 50 95 42 78 0];
C = 1;
Nindx = (1:8)';

[K] = esauWilliams(D, C, Nindx);

                                     
%% 
clear all
close all
clc

s = cputime;

M = csvread('Localidades.csv', 1, 2);
M = M(:,1:3);

% definition of the quadrant to evaluate
maxLat = 27;
minLat = 22;

maxLon = -103;
minLon = -107;

LAT = M(:,2);
LON = M(:,3);

LAT = LAT(LAT>=minLat);
LON = LON(LAT>=minLat);
LAT = LAT(LAT<=maxLat);
LON = LON(LAT<=maxLat);

LAT = LAT(LON>=minLon);
LON = LON(LON>=minLon);
LAT = LAT(LON<=maxLon);
LON = LON(LON<=maxLon);

n = length(LAT);
D = zeros(n);

for i = 1:n
    for j=i:n
            D(i,j) = distance(LAT(i), LON(i), LAT(j), LON(j));
    end
end

s = cputime - s;

save MAT_quadrantDistance;

display('Listo, tiempo de computo (en segundos):');
display(s);
    

%% pruebas Steigltz

clear all 
close all
clc

distanceMatrix = ...
    [0 3 5 4 3 4 7 8 13 11
    3 0 2 2 1 2 5 5 9 9
    5 2 0 2 2 3 6 5 9 11
    4 2 2 0 1 2 5 3 7 9
    3 1 2 1 0 1 4 4 8 8 
    4 2 3 2 1 0 3 3 7 7 
    7 5 6 5 4 3 0 1 5 4
    8 5 5 3 4 3 1 0 4 6
    13 9 9 7 8 7 5 4 0 2
    11 9 11 9 8 7 4 6 2 0];

nodes = (1:10)';
pe = randperm(10);

%% K-means tries

load MAT_fullDistance


p = lla2ecef([LAT LON 6378100.*ones(size(LAT))]);

clusterNumber = 25;

[cidx C] = kmeans(p, clusterNumber);

figure(3)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico')
for i=1:clusterNumber
    colour = 0.9.*[rand(1) rand(1) rand(1)];
    h = plotm(LAT(cidx==i),LON(cidx==i),...
        'linestyle','o','Color',colour);
    set(h, 'MarkerSize',4);
end


