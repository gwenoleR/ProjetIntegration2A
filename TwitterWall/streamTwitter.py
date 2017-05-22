import redis
import tweepy
import json
from tweepy import Stream
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler

consumer_key = 'U2c6gu2oNF2eI44X87cl0JJZt'
consumer_secret = 'IX8pXjmMqjBVKVFmmxSMhAGOb7VkLWOhqhp0W6WjMWUSSri2xm'
access_token = '864086862260031488-mDpmOf811qT8o9DSRgxgVrJ3WDFti6n'
access_secret = 'MJY0ZvP6e1fwdxKKkwk8VppsYOUkGWeHlFXw5ExCbKASH'

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)

api = tweepy.API(auth)

class StdOutListener(StreamListener):

    def on_data(self, data):
        infoToSend = {'name':'', 'screen_name':'', 'text':'', 'image': ''}
        infoTweet = json.loads(data)        
        infoToSend['name'] = infoTweet['user']['name']
        infoToSend['screen_name'] = infoTweet['user']['screen_name']
        infoToSend['text'] = infoTweet['text']
        try:
            infoToSend['image'] = infoTweet['entities']['media'][0]['media_url']
        except KeyError:
            infoToSend['image'] = ""
            pass
        r.publish('JO_Soc', json.dumps(infoToSend))
        print (data)
        return True

    def on_error(self, status):
        print (status)

r = redis.StrictRedis(host='localhost', port=6379, db=0)

test = tweepy.Cursor(api.search, q='JOIMERIR').items(10)
infoToSend = {'name':'', 'screen_name':'', 'text':'', 'image':''}
    
for tweet in test:
    infoTweet = tweet._json
    print(tweet._json)     
    infoToSend['name'] = infoTweet['user']['name']
    infoToSend['screen_name'] = infoTweet['user']['screen_name']
    infoToSend['text'] = infoTweet['text']  
    try:      
        infoToSend['image'] = infoTweet['entities']['media'][0]['media_url']
    except KeyError:
        infoToSend['image'] = ""
        pass
    r.publish('JO_Soc', json.dumps(infoToSend))
listener = StdOutListener()
stream = Stream(auth, listener)
stream.filter(track=['JOIMERIR', 'JO'])

   