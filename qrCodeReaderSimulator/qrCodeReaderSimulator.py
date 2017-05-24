import time
from pymongo import MongoClient
from bson.objectid import ObjectId
import json
import dweepy
import requests

import random
dburl = 'mongodb://soc.catala.ovh:27017/'

def initDatabase():
    client = MongoClient(dburl)
    db = client['jo']
    return db

def simulateReaders():
    qrcodeCollection = initDatabase().qrcode
    results = qrcodeCollection.find({})
    while True :
        for iot in range(1,3):
            iotname = "fakeReader-soc" + str(iot)
            nbm = random.randint(0,results.count()-1)
            tosend = {"user_id" : results[nbm]["user_id"]}
            dweepy.dweet_for(iotname,tosend)
            print( iotname , " SENDED " ,tosend)
        time.sleep(3)

if __name__ == "__main__":
    simulateReaders()