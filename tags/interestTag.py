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

@app.route("/getInterestPosts", methods=['POST'])
def getInterestTags():
        data = json.loads(request.data)
        jsonFields = checkRequest(data,["_id"])
        if jsonFields == None:
            response = {"resp":"Mauvais formatage du JSON"}
            resp = make_response(json.dumps(response),400)
            resp.headers['Content-Type'] = 'application/json'
            return resp
        _id = jsonFields[0]
        user = userExist(_id)
        if user == None:
            response = {"resp":"L'utilisateur n'existe pas !"}
            resp = make_response(json.dumps(response),400)
            resp.headers['Content-Type'] = 'application/json'
            print (response)
            return resp
        interestTags = user['tags']

        postCollection = initDatabase().posts
        reponse = []
        for tag in interestTags:
            postWithTag = postCollection.find({"tags":tag["name"]})
            for p in postWithTag:
                p["_id"] = str(p["_id"])
                reponse.append(p)
        return make_response(json.dumps(reponse),200)

@app.route("/getBestTags",methods=['GET'])
def getBestTags():
    tagsCollection = initDatabase().tags
    listTags = tagsCollection.find({})
    poids = {}
    for t in listTags:
        poids[t["_id"]] =  json.loads('{"poids": 0 , "occurence": 0 }')
    userCollection = initDatabase().user
    listUsers = userCollection.find({})
    for u in listUsers:
        tags = u["tags"]
        for t in tags:
            poids[t["name"]]["poids"] += t["weight"]
            poids[t["name"]]["occurence"] += 1
    moyennes = []
    for p in poids:
        if poids[p]["occurence"] != 0:
            moy = poids[p]["poids"] / poids[p]["occurence"]
            moyennes.append({ p : { "moyenne" : moy }})
    mo = []
    for index, m in enumerate(moyennes):
        for c in moyennes[index]:
            mo.append({"name":c , "moyenne": m[c]["moyenne"]})
    maxis = []
    for i in range(0,len(moyennes)):
        maxi = max(mo,key=lambda item:item["moyenne"])
        print(maxi)
        maxis.append(maxi)
        mo.pop(mo.index(maxi))
    liste = []
    for m in maxis:
        liste.append(m["name"])
    return make_response(json.dumps(liste),200)

@app.route("/bestTagsOfUser",methods=['POST'])
def bestTagsOfUser():
    data = json.loads(request.data)
    jsonFields = checkRequest(data,["_id"])
    if jsonFields == None:
        response = {"resp":"Mauvais formatage du JSON"}
        resp = make_response(json.dumps(response),400)
        resp.headers['Content-Type'] = 'application/json'
        return resp
    _id = jsonFields[0]
    user = userExist(_id)
    if user == None:
        response = {"resp":"L'utilisateur n'existe pas !"}
        resp = make_response(json.dumps(response),400)
        resp.headers['Content-Type'] = 'application/json'
        print (response)
        return resp
    interestTags = user['tags']

    weights = []
    for w in interestTags:
        weights.append(w["weight"])

    index = []

    for i in range(3):
        maxi = max(weights)
        a = weights.index(maxi)
        index.append(a)
        weights[a] = -1

    retour = []
    for i in index:
        retour.append(interestTags[i])
    return make_response(json.dumps({"tags" : retour}), 200)

@app.route("/bestPoiOfUser",methods=['POST'])
def bestPoiOfUser():
    data = json.loads(request.data)
    jsonFields = checkRequest(data,["_id"])
    if jsonFields == None:
        response = {"resp":"Mauvais formatage du JSON"}
        resp = make_response(json.dumps(response),400)
        resp.headers['Content-Type'] = 'application/json'
        return resp
    _id = jsonFields[0]
    user = userExist(_id)
    if user == None:
        response = {"resp":"L'utilisateur n'existe pas !"}
        resp = make_response(json.dumps(response),400)
        resp.headers['Content-Type'] = 'application/json'
        print (response)
        return resp
    interestPoi = user["poi"]
    distincPoi = list(set(interestPoi))
    print distincPoi

    bestPoi = []
    for p in distincPoi:
        print interestPoi.count(p)
        bestPoi.append(interestPoi.count(p))

    retour = []
    for i in bestPoi:
        maxi = max(bestPoi)
        print maxi
        p = bestPoi.index(maxi)
        print p
        bestPoi[p] = -1
        retour.append(distincPoi[p])

    print(retour)

    return make_response("",200)

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
    return result

if __name__ == "__main__":
    app.run(host='0.0.0.0')
