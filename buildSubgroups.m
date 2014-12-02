function [groupindx, clusterNumber] = buildSubgroups(concentrador, nodes)
% 
%                    BUILD SUBGROUPS
%
% Function to determine which nodes are being connected to each of the
% concentrators. It returns a vector of local indexes that determine if the
% ith node corresponds to the jth concentrator. The program will try and
% build one group per conecntrator, but in some cases, this might not be
% possible and some concentrators will belong to a single group.
%
%           OUTPUT:
%        groupindx := vector that shows which of the nodes belong to which
%                     group.
%    clusterNumber := number of clusters created.
%
%            INPUT:
%     concentrador := Boolean array. It shows whether the ith entry is a
%                     concentrator.
%            nodes := Nodes' ID vector.
%
% SEE ALSO dysartGeorganas.m, esauWilliams.m, steiglitzWeinerKleitman1.m
% 
%
n = length(concentrador);
nC = sum(concentrador);

% Resetting the seed so that the groups will be alike in each run.
rng(110833,'twister');
stream = RandStream.getGlobalStream;
reset(stream);

load MAT_fullDistance;
clear D;

% Building the groups
p = lla2ecef([LAT(nodes) LON(nodes) 6378100.*ones(n,1)]);
clusterNumber = nC;

[cidx C] = kmeans(p, clusterNumber,...
    'Start', p(concentrador==true,:),...
    'Distance','cityblock');
groupindx = cidx;


% PLEASE NOTE: This program does construct a set of groups that will then
% be connected to a concentrator. This is tricky, beacuse it sometimes
% gives groups that do not include a concentrator as well as groups that
% have more than one. With 'sqEuclidean' as the parameter for 'Distance' in
% the kmeans algorithm this happens a lot. 
