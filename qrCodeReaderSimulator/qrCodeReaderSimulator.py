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

def simulateIoT():
    userCollection = initDatabase().user
    results = userCollection.find({})
    results2 = []
    for res in results:
        oid = res["_id"]
        res["_id"] = str(oid)
        results2.append(res)
    while True:
        for iot in range(1,5):
            iotname = "fakeReader-soc" + str(iot)
            nbm = random.randint(0,len(results2)-1)
            
            try:
                uid = results2[nbm]["_id"]
                nom = results2[nbm]["perso"]["nom"]
                prenom = results2[nbm]["perso"]["prenom"]
                tosend = {"user_id" : uid , "Nom" : nom , "Prenom" : prenom }
                readersCollection = initDatabase().readers
                reader = readersCollection.find_one({"dweet_id":iotname})
                if reader != None:
                    poi = reader["poi_note"]
                    oid = str(ObjectId(initDatabase().poi.find_one({"note":poi})["_id"]))
                    req = requests.post("http://gps.soc.catala.ovh/userPoi",json=({"_id":uid, "poi_id": oid, "inOut":"in"}))
                    print(req.content)
                dweepy.dweet_for(iotname, {'qrcode':tosend})
                
                print (iotname)
                print( "SEND :      " , results2[nbm])
            except KeyError:
                print("Pas grave")
        pois = requests.get("http://gps.soc.catala.ovh/getAllPoi")
        data = json.loads(pois.content)
        po = data["poi"]

        usersOnSite = 0
        for index, p in enumerate(po):
            try:
                url = "poiMap-soc" + str(index+1)
                p["count"] = len(p["users"])
                usersOnSite += len(p["users"])
            except KeyError:
                p["count"] = 0

            dweepy.dweet_for(url,p)
        dweepy.dweet_for("usersOnSite-soc",{"usersOnSite":usersOnSite})
        time.sleep(1)




if __name__ == "__main__":
    simulateIoT()
    