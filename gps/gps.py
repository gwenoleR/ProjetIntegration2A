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

@app.route("/userInPoi",methods=['POST'])
def userInPoi():
    data = json.loads(request.data)
    try:
        u_id = str(data["_id"])
        poi_id = str(data["poi_id"])
    except KeyError:
        resp = make_response("Mauvais formatage du JSON",400)
        return resp
    db = initDatabase()
    userCollection = db.user
    user_oid = ObjectId(u_id)
    isUser = userCollection.find_one({"_id":user_oid})
    if isUser == None:
        resp = make_response("L'utilisateur n'existe pas !",400)
        return resp
    else:
        poiCollection = db.poi
        poi_oid = ObjectId(poi_id)
        isPoi = poiCollection.find_one({"_id":poi_oid})
        if isPoi == None:
            resp = make_response("Le poi n'existe pas !",400)
            return resp
    isUserInPoi = poiCollection.find_one({"users":u_id})
    print u_id
    print(isUserInPoi != None)
    if isUserInPoi == None:
        poiCollection.update({'_id': poi_oid}, {'$push': {'users': u_id}})
        resp = make_response("Modification bien prise en compte",200)
    else:
        resp = make_response("L'utilisateur est deja dans la zone !",400)
    return resp

if __name__ == "__main__":
    app.run(host='0.0.0.0')
