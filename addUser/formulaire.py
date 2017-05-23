from flask import Flask, request, make_response, render_template, send_file
import requests
import json
from pymongo import MongoClient
from bson.objectid import ObjectId
import time

app = Flask(__name__)

dburl = 'mongodb://soc.catala.ovh:27017/'
listType = []
listNatio = []

G_id = ""

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
    global listNatio
    natioCollection = initDatabase().nationalites
    cursor = natioCollection.find({})
    for document in cursor:
          print(document['_id'])
          listNatio.append(document['_id'])

def postQrCode(id):
    url = "http://qrcode.soc.catala.ovh/generateQrCode"

    headers = {
        "Content-Type":"application/json"        
    }
    data = {
        "user_id": id
    }
    r = requests.post(url,data=json.dumps(data),headers=headers)
    print(r.content)

@app.route('/getQrCode', methods= ['POST', 'GET'])
def showQrCode():
    global G_id
    time.sleep(2)
    url = "http://qrcode.soc.catala.ovh/getQrCode"

    headers = {
        "Content-Type":"application/json"        
    }
    data = {"user_id":G_id, "type": "html"}
    
   
    r = requests.post(url, data=json.dumps(data), headers=headers)
    
    #return render_template('index.html', qrCode= json.loads(r.content))
    string = str(r.content).replace("b'", "")
    stringToRender = string[:-1]  
    print(stringToRender)  
    
    return make_response(stringToRender,200)
    #return render_template('index.html', qrCode= stringToRender,typePerson = listType,typeNatio= listNatio)

@app.route('/')
def pageBeacon():
    return render_template('index.html', typePerson = listType,typeNatio= listNatio)


@app.route('/addUsers', methods=['POST'])
def addUsersMongo():
    global G_id
    data = request.get_json()
    print(data)
    iduser = usersCollection.insert_one(data)
    print(iduser.inserted_id)
    postQrCode(str(iduser.inserted_id))
    G_id = str(iduser.inserted_id)
    resp = make_response('"Compte crée"', 200)
    resp.mimetype = 'application/json'
    return resp



if __name__ == '__main__':    
    getType()
    getNationalite()
    app.run()

