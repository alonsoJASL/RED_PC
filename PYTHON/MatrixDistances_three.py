# from urllib2 import Request, urlopen
from urllib.request import Request, urlopen 
import json
import pandas as pd
# from StringIO import StringIO
from io import StringIO
import numpy as np
import googlemaps
import time
import csv
#import matplotlib.pyplot as plt

# Modify with own key
keyJASL = 'AIzaSyDVWjCMy78Zuk244tB3duLXCK2vSn6NhTQ'
keyISAAC = 'AIzaSyCRVZD_oqSEeHGn0T74_O_eedqgcoWW-hc'
gmaps = googlemaps.Client(key=keyJASL)

fileNames = ['Chihuahua_grupo.csv','Puebla_grupo.csv',
             'ChiapasTuxtla_grupo.csv']

# Starting with Chihuahua
Locations =  {'idx':[],
             'jdx':[],
             'start_lat':[],
             'start_lon':[],
             'finish_lat':[],
             'finish_lon':[],
             'distance':[]}

with open(fileNames[0],'r') as f:
    for line in f.readlines():
        i,j,stlat,stlon,flat,flon, dist = line.strip().split(',')
        Locations['idx'].append(int(i))
        Locations['jdx'].append(int(j))
        Locations['start_lat'].append(float(stlat))
        Locations['start_lon'].append(float(stlon))
        Locations['finish_lat'].append(float(flat))
        Locations['finish_lon'].append(float(flon))
        Locations['distance'].append(float(dist))
        #Locations.append([int(i),int(j),float(stlat),float(stlon),
        #                  float(flat),float(flon),float(dist)])
    f.close()

size_Locations = len(Locations['idx'])

print('Read CSV file, about to compute distances')

for i in range(0,size_Locations):
    #directions_result = gmaps.directions((Locations[i][2],Locations[i][3]),
    #                                  (Locations[i][4],Locations[i][5]),
    #                                  region = "mx")
    directions_result = gmaps.directions((Locations['start_lat'][i],
                                      Locations['start_lon'][i]),
                                      (Locations['finish_lat'][i],
                                       Locations['finish_lon'][i]),
                                      region = "mx")
    directions = directions_result[0]['legs'][0]
    
    Locations['distance'][i] = directions['distance']['value']/1000

    if i==(size_Locations/2):
        print('     We\'re about half way!')

print('We\'re done computing distances, creating new CSV file...')

df = pd.DataFrame(data=Locations,columns=
                  ['idx','jdx','start_lat',
                   'start_lon','finish_lat',
                   'finish_lon','distance'])

filetoSave = 'Distance_'+fileNames[0]

ff = open(filetoSave,'w')
df.to_csv(ff,header=False)
ff.close()
# DONE!
