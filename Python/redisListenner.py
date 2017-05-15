import redis
import json

r = redis.StrictRedis(host='localhost', port=6379, db=0)
listener = r.pubsub()

listener.subscribe(['JO_Soc'])

listTweet = {'name':'', 'screen_name':'', 'text':'', 'image': ''}
for item in listener.listen():
    if(item['data'] != 1):
        
        itemJsonned = json.loads(item['data'].decode("utf-8"))
        print(itemJsonned)
        listTweet['name'] = itemJsonned['name']
        print("Nom: ", itemJsonned['name'])
        print("Nom d'affichage: ", itemJsonned['screen_name'])
        print("Message: ", itemJsonned['text'])
        print("image: ", itemJsonned['image'])
    


    