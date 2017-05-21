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

@app.route("/userPoi",methods=['POST'])
def userPoi():
    data = json.loads(request.data)
    jsonFields = checkRequest(data,["_id","poi_id","inOut"])
    if jsonFields == None:
        resp = make_response("Mauvais formatage du JSON",400)
        return resp
    else:
        u_id = jsonFields[0]
        poi_id = jsonFields[1]
        inOut = jsonFields[2]
    if userExist(u_id) == False:
        resp = make_response("L'utilisateur n'existe pas !",400)
        return resp
    elif poiExist(poi_id) == False:
            resp = make_response("Le poi n'existe pas !",400)
            return resp
    if inOut not in ["in","out"]:
        resp = make_response("Mauvaise instruction in/out",400)
        return resp

    poiCollection = initDatabase().poi
    isUserInPoi = poiCollection.find_one({"users":u_id,"_id":ObjectId(poi_id)})
    if isUserInPoi == None:
        if inOut == "in":
            oldPoi = poiCollection.find_one({"users":u_id})
            if oldPoi != None:
                poiCollection.update({'_id': oldPoi["_id"]}, {'$pull': {'users': u_id}})
            poiCollection.update({'_id': ObjectId(poi_id)}, {'$push': {'users': u_id}})
            resp = make_response("Modification d'entree en zone bien prise en compte",200)
        else:
            resp = make_response("L'utilisateur n'etait pas dans la zone !",400)
            return resp
    else:
        if inOut == "out":
            poiCollection.update({'_id': ObjectId(poi_id)}, {'$pull': {'users': u_id}})
            resp = make_response("Modification de sortie de zone bien prise en compte",200)
        else:
            resp = make_response("L'utilisateur est deja dans la zone !",400)
    return resp

@app.route("/getUsersInPoi",methods=["POST"])
def getUsersInPoi():
    data = json.loads(request.data)
    jsonFields = checkRequest(data,["poi_id"])
    if jsonFields == None:
        resp = make_response("Mauvais formatage du JSON",400)
        return resp
    else:
        poi_id = jsonFields[0]
    poiCollection = initDatabase().poi
    result = poiCollection.find_one({"_id":ObjectId(poi_id)})
    if result == None:
        resp = make_response("Le poi demande n'existe pas !",400)
        return resp
    else:
        users = result["users"]
        resp = make_response(json.dumps(users),200)
        resp.headers['Content-Type'] = 'application/json'
    return resp

def checkRequest(data,required):
    try:
        d = []
        for r in required:
            d.append(str(data[r]))
    except KeyError:
        return None
    return d

def userExist(uid):
    userCollection = initDatabase().user
    oid = ObjectId(uid)
    result = userCollection.find_one({"_id":oid})
    return result != None

def poiExist(poiid):
    poiCollection = initDatabase().poi
    oid = ObjectId(poiid)
    result = poiCollection.find_one({"_id":oid})
    return result != None

if __name__ == "__main__":
    app.run(host='0.0.0.0')
