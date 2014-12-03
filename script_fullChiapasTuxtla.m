% script_fullChiapasTuxtla.m
%
% Computes:
% - Matrix for Chiapas-Tuxtla group.
% - Dysart-Georganas algorithm.
% - Steiglitz-Weiner-Kleitman algorithm for Dysart's 
%   concentrators (along with Chiapas-Tuxtla city)
% - Plot of group, with connected concentrators.
% 

clear all
close all
clc

load MAT_CHTUX
load MAT_fullDistance

POB_CHTUX = POB(nodes_CHTUX);

[nodos concentrador v freqs] = ...
    dysartGeorganas(4, nodes_CHTUX, dist_CHTUX);

% force Chiapas/Tuxtla City into the main nodes.
concentrador(LAT(nodes_CHTUX)==CHTUX(1)) = true;
concentrador(POB_CHTUX<=20000) = false;

Dc = dist_CHTUX(concentrador==true, ...
                concentrador==true);
%
[Kc, totDist, defi, permi] = ...
    steiglitzWeinerKleitman1(Dc, concentrador, ...
                            nodes_CHTUX, 2, 100);
                        
                        
[groupindx, numberOfGroups] = buildSubgroups(concentrador,...
                                             nodes_CHTUX,...
                                             dist_CHTUX);
CM_CHTUX = zeros(size(dist_CHTUX)); % full conectivity matrix.
concentrators = nodes_CHTUX(concentrador==true);

localindx = 1:length(nodes_CHTUX);
for i=1:numberOfGroups
    Dindx = dist_CHTUX(groupindx==i,groupindx==i);
    Nindx = nodes_CHTUX(groupindx==i);
    Cindx = concentrators(i);
    
    Kret = esauWilliams(Dindx, Cindx, Nindx);
    CM_CHTUX(groupindx==i,groupindx==i) = Kret;
end
                            
%% Plot
clc
% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

% LatLong discriminated by concentrators
LATc = LAT(nodes_CHTUX(concentrador==true));
LONc = LON(nodes_CHTUX(concentrador==true));

LATnc = LAT(nodes_CHTUX(concentrador==false));
LONnc = LON(nodes_CHTUX(concentrador==false));

LATch = LAT(nodes_CHTUX);
LONch = LON(nodes_CHTUX);

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico - CHIAPAS/TUXTLA');

n = length(nodes_CHTUX);

for i=1:n
    for j=1:n
        if CM_CHTUX(i,j)~=0
            h = plotm([LATch(i) LONch(i); LATch(j) LONch(j)],...
                'o-','Color','b');
            set(h, 'MarkerSize',marker);
        end
    end
end

nc = sum(concentrador);
I = [];

for i=1:nc
    for j=1:nc
        if Kc(i,j)~=0
            I = [I;i j];
            h = plotm([LATc(i) LONc(i); LATc(j) LONc(j)],...
                '+-','Color','m');
            set(h, 'MarkerSize',bigmarker);
        end
    end
end

h = plotm([LATc(nc) LONc(nc); LATc(1) LONc(1)],...
           '*-','Color','m');
set(h, 'MarkerSize',bigmarker);

h = plotm(LATnc, LONnc,...
    'linestyle','o','Color','b');
set(h, 'MarkerSize',marker);

h = plotm(CHTUX,...
    'linestyle','o','Color','k');
set(h, 'MarkerSize',bigmarker);
