from flask import Flask, request, make_response, render_template
import requests
import json
from OpenSSL import SSL 
import os

context = SSL.Context(SSL.SSLv23_METHOD)
cer = os.path.join(os.path.dirname(__file__), 'resources/udara.com.crt')
key = os.path.join(os.path.dirname(__file__), 'resources/udara.com.key')

url = "http://soc.catala.ovh/v2/translate"
drapeauxPays = ["🇺🇸", "🇪🇸", "🇫🇷", "🇩🇪", "🇮🇹", "🇧🇷"]
model_id = ["en-es", "en-fr", "en-de", "en-it", "en-pt"]
phraseATraduire = "Welcome,you are near the Toto stadium! You can buy your country flag at the stadium's store"
phraseTraduites = ["", "", "", "", ""]


app = Flask(__name__)

def getTraduction():

    headers = {
        "Content-Type":"application/json",
        "Host": "translator.soc.docker"
    }

    for i in range(0, 5):
        
        data = {
            "model_id":model_id[i],"source":"fr","target":"es", "text":phraseATraduire
        }

        r = requests.post(url,data=json.dumps(data),headers=headers)
        rNoJsoned = r.json()
        print(rNoJsoned)
        phraseTraduites[i] = rNoJsoned


@app.route('/')
def pageBeacon():
    return render_template('index.html', listDrapeaux = drapeauxPays, listPhraseTraduites = phraseTraduites, phraseEnglish = phraseATraduire)


if __name__ == '__main__':    
    
    getTraduction()
    context = (cer, key)
    app.run( host='0.0.0.0', ssl_context=context)