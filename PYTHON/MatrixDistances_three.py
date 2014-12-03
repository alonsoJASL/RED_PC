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
keyIVI = 'AIzaSyDdRsqVOSuf_rsTBcWGdw02qgs5uGQe9-Y'
keyOros = 'AIzaSyBD60IkWt5RC24XuZPRQG3yHaZX20YNCP0'
keyMAYTE = 'AIzaSyDiTs4L73aA2b3sIYfsSCLL8AcJm1n_g1w'
keyJOAN = 'AIzaSyBAWQAnJV_L7vYlzyyKy4H-vmg4tBClCLQ'
keyDeLINT = 'AIzaSyBNjDdSkn7YbOL-VtkU8IheoCQKNJk0DNg'
keyANDRE = 'AIzaSyD7-JGjlCrNb7Ic0P44mmci3zUXJClkFEI'

keys = [keyANDRE, 
        keyISAAC, keyJOAN, keyDeLINT,
        keyIVI, keyOros, keyMAYTE, keyJASL]

keycount = 0
gmaps = googlemaps.Client(key=keys[keycount])

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

print('We\'re doing: '+fileNames[1])
s = time.time()

with open(fileNames[1],'r') as f:
    for line in f.readlines():
        i,j,stlat,stlon,flat,flon, dist = line.strip().split(',')
        Locations['idx'].append(int(i))
        Locations['jdx'].append(int(j))
        Locations['start_lat'].append(float(stlat))
        Locations['start_lon'].append(float(stlon))
        Locations['finish_lat'].append(float(flat))
        Locations['finish_lon'].append(float(flon))
        Locations['distance'].append(float(dist))
    f.close()

size_Locations = len(Locations['idx'])

print('Read CSV file, about to compute distances')

for i in range(0,size_Locations):
    directions_result = gmaps.directions((Locations['start_lat'][i],
                                      Locations['start_lon'][i]),
                                      (Locations['finish_lat'][i],
                                       Locations['finish_lon'][i]),
                                      region = "mx")
    directions = directions_result[0]['legs'][0]
    
    Locations['distance'][i] = directions['distance']['value']/1000

    if i%2500==0 and i!=0:
        keycount = keycount + 1
        print('     We\'re changing the key to: ')
        print('    '+str(keys[keycount]))
        print('     We\'re getting there!')
        gmaps=googlemaps.Client(keys[keycount])

print('We\'re done computing distances, creating new CSV file...')

df = pd.DataFrame(data=Locations,columns=
                  ['idx','jdx','start_lat',
                   'start_lon','finish_lat',
                   'finish_lon','distance'])

filetoSave = 'Distance_'+fileNames[1]

ff = open(filetoSave,'w')
df.to_csv(ff,header=False)
ff.close()
s= time.time() - s
# Closing statements
print('We did about: '+str(size_Locations)+' consults to Google,')
print('taking about '+ str(s) + ' seconds.')
print('All set, bye!')
# DONE!
