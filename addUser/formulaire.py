from flask import Flask, request, make_response, render_template, send_file
import requests
import json
from pymongo import MongoClient
from bson.objectid import ObjectId

app = Flask(__name__)

dburl = 'mongodb://soc.catala.ovh:27017/'
listType = []
listNatio = []

def initDatabase():
    client = MongoClient(dburl)
    db = client['jo']
    return db

usersCollection = initDatabase().user

def getType():
    typeCollection = initDatabase().typePersonne
    cursor = typeCollection.find({})
    for document in cursor:
          print(document['_id'])
          listType.append(document['_id'])

def getNationalite():
    natioCollection = initDatabase().nationalites
    cursor = natioCollection.find({})
    for document in cursor:
          print(document['_id'])
          listType.append(document['_id'])

@app.route('/')
def pageBeacon():
    return render_template('index.html', typePerson = listType)


@app.route('/addUsers', methods=['POST'])
def addUsersMongo():
    
    data = request.get_json()
    print(data)
    iduser = usersCollection.insert_one(data)
    print(iduser.inserted_id)
    resp = make_response('"Compte crée"', 200)
    resp.mimetype = 'application/json'
    return resp

if __name__ == '__main__':    
    getType()
    getNationalite()
    app.run(host="0.0.0.0")

