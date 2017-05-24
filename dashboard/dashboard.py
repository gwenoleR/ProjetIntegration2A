import dweepy
import requests
from pymongo import MongoClient
from bson.objectid import ObjectId
import time
import json

readers = []
pois = []
dburl = 'mongodb://soc.catala.ovh:27017/'

def init():
    initReaders()
    initPois()
    initScreens()

def initDatabase():
    client = MongoClient(dburl)
    db = client['jo']
    return db

def initReaders():
    readersCollection = initDatabase().readers
    result = readersCollection.find({})
    for r in result:
        readers.append({"dweet_id" : r["dweet_id"],"last_dweet": None,"note": r["poi_note"]})

def initPois():
    poisCollection = initDatabase().poi
    result = poisCollection.find({})
    for r in result:
        pois.append({"poi_id": str(r['_id']), "note": r["note"]})

def initScreens():
    for r in readers: 
        response = requests.get("http://beacon.catala.ovh")
        if response.status_code == 200:
            html = response.content
            tosend = {"html": html}
            screenName = "html-" + r["dweet_id"]
            dweepy.dweet_for(screenName ,tosend)
    

def listenDweets():
    for r in readers :
        dweet = dweepy.get_latest_dweet_for(r["dweet_id"])
        if r['last_dweet'] != dweet[0]["created"]:
            print(dweet)
            try:
                sendRequestCheckQrcode(str(dweet[0]["content"]["user_id"]),r)
            except KeyError:
                print("no value QrCode")
            r['last_dweet'] = dweet[0]["created"]

def sendRequestCheckQrcode(uid,reader):
    url = "http://qrcode.soc.catala.ovh/checkQrCode"
    headers = {
        "Content-Type":"application/json"
    }
    data = {
        "user_id": uid
    }
    r = requests.post(url,data= json.dumps(data),headers=headers)
    print(r.status_code)
    if r.status_code == 200:
        res = json.loads(r.content)
        tosend = { "user_id" : res["_id"] , "Nom" : res["perso"]["nom"] , "Prenom" : res["perso"]["prenom"] }
        screenName = "screen-" + reader["dweet_id"]
        dweepy.dweet_for(screenName,tosend)
        sendRequestUserPoi(uid,reader,"in")

def sendRequestUserPoi(uid,reader,inOut):
    url = "http://gps.soc.catala.ovh/userPoi"
    poi = ""
    for p in pois:
        if p["note"] == reader["note"]:
            poi = p["poi_id"]
    headers = {
        "Content-Type":"application/json"
    }
    data = {
        "_id": uid,
        "poi_id": poi,
        "inOut": inOut
    }
    r = requests.post(url,data= json.dumps(data),headers=headers)
    print(r.content)

def sendDweetForUsersInSite():
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

def sendDweetForBestTags():
    result = requests.get("http://tags.soc.catala.ovh/getBestTags")
    try : 
        tags = json.loads(result.content)
        bestTags = {"tags" : tags}
        dweepy.dweet_for("tagsDash-soc", bestTags)
    except ValueError:
        print("")
if __name__ == "__main__":
    init()
    while(True):
        listenDweets()
        sendDweetForUsersInSite()
        sendDweetForBestTags()