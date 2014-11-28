% Load Distance Matrix
%

%% CHIHUAHUA
clear all
close all
clc

cd ./PYTHON/

CSV_CHIH = csvread('Distance_Chihuahua_grupo.csv',0,1);

cd ..
%
n_CHIH = length(CSV_CHIH(CSV_CHIH(:,1)==CSV_CHIH(1,1),1));
dist_CHIH = zeros(n_CHIH);

count = 1;

for i=1:n_CHIH
    for j=i:n_CHIH
        if i~=j
            dist_CHIH(i,j) = CSV_CHIH(count,7);
            count=count+1;
        end
    end
end
dist_CHIH = dist_CHIH + dist_CHIH';
nodes_CHIH = unique(CSV_CHIH(:,1));

CHIH = [28.67113 -106.10523];

clear count i j;

save MAT_CHIH

%% CHIAPAS (TUXTLA)

clear all
close all
clc
%
cd ./PYTHON/

CSV_CHTUX = csvread('Distance_ChiapasTuxtla_grupo.csv',0,1);

cd ..
%
n_CHTUX = ...
    length(CSV_CHTUX(CSV_CHTUX(:,1)==CSV_CHTUX(1,1),1));
dist_CHTUX = zeros(n_CHTUX);

count = 1;

for i=1:n_CHTUX
    for j=i:n_CHTUX
        if i~=j
            dist_CHTUX(i,j) = CSV_CHTUX(count,7);
            count=count+1;
        end
    end
end
dist_CHTUX = dist_CHTUX + dist_CHTUX';
nodes_CHTUX = unique(CSV_CHTUX(:,1));

CHTUX = [16.746 -93.13263];

clear count i j;

save MAT_CHTUX


%% Dysart-Georganas

load MAT_fullDistance

% Here we have loaded: 
%
% -----------------------------------------------
%   Name   |      Size    |      Bytes  Class  
% -----------------------------------------------
%   D      |   3651x3651  |  106638408  double              
%   LAT    |   3651x1     |      29208  double              
%   LON    |   3651x1     |      29208  double
%   IDS    |   3651x1     |      29208  double
%   TOTAL  |      1x1     |          8  double              
% -----------------------------------------------

[nodos concentrador v freqs] = ...
    dysartGeorganas(1, nodes_CHIH, dist_CHIH);

%Cindx = nodos(concentrador==true);
%[K] = esauWilliams(dist_CHIH, Cindx(1), nodos);


%% Plot
% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

% LatLong discriminated by concentrators
LATc = LAT(nodes_CHIH(concentrador==true));
LONc = LON(nodes_CHIH(concentrador==true));

LATnc = LAT(nodes_CHIH(concentrador==false));
LONnc = LON(nodes_CHIH(concentrador==false));

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico - CHIHUAHUA');
h = plotm(LATc, LONc,...
    '+-','Color',cities);
set(h, 'MarkerSize',bigmarker);    
h = plotm(LATnc, LONnc,...
    'linestyle','o','Color',colour);
set(h, 'MarkerSize',marker);

h = plotm(CHIH,...
    'linestyle','o','Color','k');
set(h, 'MarkerSize',bigmarker);

    

