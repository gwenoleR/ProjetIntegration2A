import pyqrcode
import sys
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

@app.route("/generateQrCode",methods=['POST'])
def genererQrCode():
    data = json.loads(request.data)
    uid = str(data['user_id'])
    exist = qrCodeExist(uid)
    if exist == True:
        print("Le qrcode existe deja en base de donnee pour cet utilisateur")
        resp = make_response("Le qrcode existe deja en base de donnee pour cet utilisateur",400)
    else:
        newqrcode = pyqrcode.create(uid)
        imageB64 = newqrcode.png_as_base64_str(scale=5)
        print("imageB64 = " , imageB64)
        insertQrCodeInDb(uid,imageB64)
        resp = make_response("qrcode created and inserted in database ! ",200)
    print(resp)
    return resp

@app.route("/checkQrCode",methods=['POST'])
def checkQrCode():
    data = json.loads(request.data)
    uid = str(data['read'])
    exist = qrCodeExist(uid)
    if exist == True:
        o_uid = ObjectId(uid)
        user_information = getUserInformation(o_uid)
        user_information["_id"] = uid
        resp = make_response(json.dumps(user_information),200)
        resp.headers['Content-Type'] = 'application/json'
    else:
        resp = make_response("Le qrcode n'existe pas en base de donnee, entree invalide !",400)
    return resp

@app.route("/getQrCode",methods=['POST'])
def getQrCode():
    data = json.loads(request.data)
    uid = str(data['user_id'])
    exist = qrCodeExist(uid)
    if exist == True:
        qrcodeCollection = initDatabase().qrcode
        qrcode_png64 = qrcodeCollection.find_one({"user_id":uid})["image_b64"]
        htmlPng= '<img src="data:image/png;base64,' + qrcode_png64 + '">'
        print(htmlPng)
        resp = make_response(htmlPng,200)
        resp.headers['Content-Type'] = 'text/html'
    else:
        resp = make_response("Le qrcode n'existe pas en base de donnee, entree invalide !",400)
    return resp

def insertQrCodeInDb(uid,imageB64):
    qrcodeCollection = initDatabase().qrcode
    toInsert = {"image_b64":imageB64,"user_id":uid}
    qrId = qrcodeCollection.insert_one(toInsert)
    print("Image inserted in database with id = ", qrId)

def qrCodeExist(uid):
    qrcodeCollection = initDatabase().qrcode
    result = qrcodeCollection.find_one({"user_id":uid})
    return result != None
    
def getUserInformation(object_id):
    userCollection = initDatabase().user
    result = userCollection.find_one({"_id":object_id})
    return result

if __name__ == "__main__":
    app.run(host='0.0.0.0')
    print("Genere")