% script

clear all
close all
clc

fileName = 'Localidades.csv';

fid = fopen(fileName,'r');
C = textscan(fid, repmat('%s',1,10), 'delimiter',',', 'CollectOutput',true);
C = C{1};
fclose(fid);