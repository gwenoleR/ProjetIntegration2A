# coding: utf8
import tweepy
import json
from tweepy import Stream
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from watson_developer_cloud import PersonalityInsightsV3
from os.path import join, dirname
import datetime
from flask import Flask, request, make_response, render_template
from pymongo import MongoClient
from bson.objectid import ObjectId

app = Flask(__name__)
dburl = 'mongodb://soc.catala.ovh:27017/'

consumer_key = 'U2c6gu2oNF2eI44X87cl0JJZt'
consumer_secret = 'IX8pXjmMqjBVKVFmmxSMhAGOb7VkLWOhqhp0W6WjMWUSSri2xm'
access_token = '864086862260031488-mDpmOf811qT8o9DSRgxgVrJ3WDFti6n'
access_secret = 'MJY0ZvP6e1fwdxKKkwk8VppsYOUkGWeHlFXw5ExCbKASH'

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
api = tweepy.API(auth)

personality_insights = PersonalityInsightsV3(
  version='2016-10-20',
  username='c55b2151-3208-40c0-a7c4-bcb81dd92c3c',
  password='eyz2456xE87H')

def initDatabase():
    client = MongoClient(dburl)
    db = client['jo']
    return db

def writeProfileInDb(dataToWrite):
    try:
        profilingCollection.insert_one(dataToWrite)
    except pymongo.errors.OperationFailure as e:
        print("Error when writing in the Db")
        return False
    return True

def replaceTimestamp(date):
    stringTomodif = date.timestamp()
    return str(stringTomodif).replace(".0","")


class TweetListener(StreamListener):
    
    def on_data(self, data):
        print (data)
        return True

    def on_error(self, status):
        print (status)
        return False

def getBehavior(name):

    jsonTosend = {'contentItems': ['']}
    jsonValue = {'content': '', 'contenttype': 'text/plain', 'created': '', 'id':'', 'language': ''}
    jsonTab = []

    twitterStream = Stream(auth,TweetListener())
    user = api.user_timeline(screen_name = name, count = 1000, include_rts = True)

    for tweets in user:    

        chaine = str(tweets.text).encode('utf8')
        toto = str(chaine).replace("b", "")
        jsonValue['content'] = toto
        jsonValue['id'] = tweets.id
        jsonValue['language'] = tweets.lang    
        jsonValue['created'] = replaceTimestamp(tweets.created_at)        
        jsonTab.append(jsonValue)
        jsonValue = {'content': '', 'contenttype': 'text/plain', 'created': '', 'id':'', 'language': ''}
    
    jsonTosend['contentItems'] = jsonTab
    
    fichierJsonToSend = open('./profile.json','w')
    fichierJsonToSend.write(json.dumps(jsonTosend))
    fichierJsonToSend.close()

    with open(join(dirname(__file__), 'profile.json')) as profile_json:
        profile = personality_insights.profile(
        profile_json.read(), content_type='application/json',
        raw_scores=True, consumption_preferences=True)

    return (json.dumps(profile, indent=2))
    

def decryptBehavior(behavior, twitterName):
    data = json.loads(behavior)   

    big5 = []
    big5Dict = {"name": "", "percentage": ""}
    big5Json = {"personality": [""]}
    for i in range(0, 5):
        big5Dict["name"] = data["personality"][i]["name"]
        big5Dict["percentage"] = data["personality"][i]["percentile"]
        big5.append(big5Dict)
        big5Dict = {"name": "", "percentage": ""}
    big5Json["personality"] = big5    

    needs = []
    needDict = {"name": "", "percentage": ""}
    needJson = {"needs": [""]}
    for i in range(0, 12):
        needDict["name"] = data["needs"][i]["name"]
        needDict["percentage"] = data["needs"][i]["percentile"]
        needs.append(needDict)
        needDict = {"name": "", "percentage": ""}    
    
    values = []
    valuesDict = {"name": "", "percentage": ""}
    valuesJson = {"values": [""]}
    for i in range(0, 5):
        valuesDict["name"] = data["values"][i]["name"]
        valuesDict["percentage"] = data["values"][i]["percentile"]
        values.append(valuesDict)
        valuesDict = {"name": "", "percentage": ""}
    
    
    behaviorParsed = {"arobase": twitterName, "behavior": {"big5" : [""], "needs": [""], "values": [""] }}
    behaviorParsed["behavior"]["big5"] = big5Json
    behaviorParsed["behavior"]["needs"] = needs
    behaviorParsed["behavior"]["values"] = values

    print(behaviorParsed)
    isOk = writeProfileInDb(behaviorParsed)
    

def isUserExistInTwitter(username):
    try:
        users = api.get_user(username)
    except tweepy.TweepError as e:
        return e
    return True
       
def isUserExistInDB(username):
    retour = profilingCollection.find_one({"arobase":username})
    if(retour == None):
        return False
    else:
        return True

@app.route('/', methods=['POST'])
def behavior():    
    
    data = request.get_json()    
    twitterName = data['twitterName']
    isOk = isUserExistInTwitter(twitterName)
    if(isOk == True):
        isUserInDb = isUserExistInDB(twitterName)
        if(isUserInDb == False):
            behaviorJson = getBehavior(twitterName)
            decryptBehavior(behaviorJson, twitterName)
            resp = make_response(json.dumps("Behavior send successfull"), 200)
            resp.mimetype = 'application/json'
            return resp
        else:
            resp = make_response(json.dumps("This user already exists in DB"), 400)
            resp.mimetype = 'application/json'
            return resp
    else:
        resp = make_response(json.dumps("This user doesn't exist"), 400)
        resp.mimetype = 'application/json'
        return resp

profilingCollection = initDatabase().profiling

if __name__ == '__main__':   
    app.run(host='0.0.0.0')