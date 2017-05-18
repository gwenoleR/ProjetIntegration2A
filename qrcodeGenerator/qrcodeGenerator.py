import qrcode
import sys
import json
from pymongo import MongoClient
import os
import gridfs
import StringIO
import base64
from bson.objectid import ObjectId

from flask import Flask, request, make_response,send_file

app = Flask(__name__)

dburl = 'mongodb://soc.catala.ovh:27017/'

@app.route("/generateQrCode",methods=['POST'])
def generateQrCode():
    data = json.loads(request.data)
    uid = str(data['user_id'])
    print(uid)
    response = None
    user_exist = checkUser(uid)
    if user_exist == True:
        print("L'utilisateur existe")
        exist = checkQrCodeExist(uid)
        if exist == False:
            print("On cree le qrcode")
            fileID = generateQrCode(uid)
            if fileID != None:
                insertQrCodeRecord(uid,fileID)
                response = "Le qrcode a ete inscrit en base de donnee !"
            else:
                response = "Erreur dans l'insription en base"
        else:
            print("Le qrcode existe deja")
            response = "Le qrcode existe deja !"
    else:
        print("L'utilisateur n'existe pas")
        response = "L'utilisateur n'existe pas"
    return response

@app.route("/checkQrCode",methods=['POST'])
def checkQrCode():
    data = json.loads(request.data)
    codeRead = str(data['read'])
    client = MongoClient(dburl)
    db = client['jo']
    qrcodeCollection = db.qrcode
    qrcode = qrcodeCollection.find_one({"user_id": codeRead})
    
    if qrcode != None:
        oid = ObjectId(codeRead)
        user = db.user.find_one({"_id":oid})
        print("REQUETE CHERCHEE : ", user)
        user['_id'] = codeRead
        resp = make_response(json.dumps(user),200)
        resp.headers['Content-Type'] = 'application/json'
        print(resp)
    else:
         resp = make_response("",400)
         print resp 
    return resp

@app.route("/getQrCode",methods=['POST'])
def getQrCode():
    data = json.loads(request.data)
    uid = str(data['_id'])
    print("Uid recu = " , uid)
    if checkQrCodeExist(uid) == True:
        client = MongoClient(dburl)
        db = client['jo']
        qrcodeCollection = db.qrcode
        qrcode = qrcodeCollection.find_one({"user_id": uid})

        print("Qrcode recu " , qrcode)
        file_id = qrcode['file_id']
        fs = gridfs.GridFS(db)
        oid = ObjectId(file_id)
        print("Oid = " , oid)
        img_io = fs.get(oid)
        print(img_io.upload_date)
        print("Image info = ", type(img_io))

        resp = send_file(img_io, mimetype='image/jpeg')
    else:
        print("Error")
        resp = make_response("",404)
    return resp
    
def insertQrCodeRecord(uid,fileID):
    client = MongoClient(dburl)
    db = client['jo']
    qrcodes = db.qrcode
    record = {"file_id":str(fileID),"user_id":uid}
    print(record)
    qrcodes.insert_one(record)

def generateQrCode(uid):
    if uid != None:
        data = str(uid)
        print("Data to generate : " , data) 
        img = qrcode.make(data)
        print ("QrCode generated !")
        print(img)
        img_io = StringIO.StringIO()
        img.save(img_io, 'JPEG', quality=70)

        imageEncodee = base64.b64encode(img_io.getvalue())
        print(imageEncodee)

        print("image Saved")

        client = MongoClient(dburl)
        db = client['jo']
        fs = gridfs.GridFS(db)
        fileID = fs.put(img_io)
        out = fs.get(fileID)
        print (out.length)
        return fileID
    else:
        print("Nothing to generate, please put a string")
        return None


    

def checkQrCodeExist(uid):
    client = MongoClient(dburl)
    db = client['jo']
    qrcodeCollection = db.qrcode
    qrcode = qrcodeCollection.find_one({"user_id": uid})
    print ("Resultat requete qrcode mongoDB = " , qrcode)
    return qrcode != None

def checkUser(uid):
    client = MongoClient(dburl)
    db = client['jo']
    userCollection = db.user
    oid = ObjectId(uid)
    print(oid)
    user = userCollection.find_one({"_id": oid})
    print ("Resultat requete user mongoDB = " , user)
    return user != None

if __name__ == "__main__":
    #generateQrCode("oktrokrofkrofko")
    app.run(host='0.0.0.0')