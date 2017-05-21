import json
from pymongo import MongoClient
from bson.objectid import ObjectId

from flask import Flask, request, make_response,send_file

app = Flask(__name__)

dburl = 'mongodb://soc.catala.ovh:27017/'

def initDatabase():
    client = MongoClient(dburl)
    db = client['jo']
    return db


@app.route("/getAllPoi",methods=['GET'])
def getAllPoi():
    poiCollection = initDatabase().poi
    pois = poiCollection.find({})
    lesPoi = []
    for p in pois:
        p["_id"] = str(p["_id"])
        lesPoi.append(p)
    toSend = {"poi" : lesPoi}
    print(toSend)
    resp = make_response(json.dumps(toSend),200)
    resp.headers['Content-Type'] = 'application/json'
    return resp

if __name__ == "__main__":
    app.run(host='0.0.0.0')
