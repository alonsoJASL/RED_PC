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

[nodos concentrador v freqs] = ...
    dysartGeorganas(1, nodes_CHTUX, dist_CHTUX);

POB_CHTUX = POB(nodes_CHTUX);

concentradorPonderado = concentrador(POB_CHTUX>=5000);

% force Chiapas/Tuxtla City into the main nodes.
concentrador(LAT(nodes_CHTUX)==CHTUX(1)) = true;
concentradorPonderado(LAT(nodes_CHTUX)==CHTUX(1)) = true;

Dc = dist_CHTUX(concentradorPonderado==true, ...
                concentradorPonderado==true);
%
clc
[Kc, totDist, defi, permi] = ...
    steiglitzWeinerKleitman1(Dc, concentradorPonderado, ...
                            nodes_CHTUX, 3, 100);
                            
% Plot
clc
% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

% LatLong discriminated by concentrators
% LATc = LAT(nodes_CHTUX(concentrador==true));
% LONc = LON(nodes_CHTUX(concentrador==true));
% 
% LATnc = LAT(nodes_CHTUX(concentrador==false));
% LONnc = LON(nodes_CHTUX(concentrador==false));

LATc = LAT(nodes_CHTUX(concentradorPonderado==true));
LONc = LON(nodes_CHTUX(concentradorPonderado==true));

LATnc = LAT(nodes_CHTUX(concentradorPonderado==false));
LONnc = LON(nodes_CHTUX(concentradorPonderado==false));

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico - CHIAPAS/TUXTLA');
h = plotm(LATnc, LONnc,...
    'linestyle','o','Color',colour);
set(h, 'MarkerSize',marker);

h = plotm(CHTUX,...
    'linestyle','o','Color','k');
set(h, 'MarkerSize',bigmarker);

% nc = sum(concentrador);
nc = sum(concentradorPonderado);
I = [];

for i=1:nc
    for j=1:nc
        if Kc(i,j)~=0
            I = [I;i j];
            h = plotm([LATc(i) LONc(i); LATc(j) LONc(j)],...
                '+-','Color',cities);
            set(h, 'MarkerSize',bigmarker);
        end
    end
end

h = plotm([LATc(nc) LONc(nc); LATc(1) LONc(1)],...
           '+-','Color',cities);
set(h, 'MarkerSize',bigmarker);

