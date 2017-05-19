import json
from flask import Flask, request, make_response
from watson_developer_cloud import LanguageTranslatorV2

app = Flask(__name__)

language_translator = LanguageTranslatorV2(
    username='cb384893-5d32-44e7-83ea-85dfb79bf5b9',
    password='OLg13FG8CBXO')

listLangages = []
listLangagesForJson = {"models":{"model_id":[""]}}

def getLangagesAvailable():

    langagesJson = json.dumps(language_translator.get_models(), indent=2)
    langagesPythonList = json.loads(langagesJson)
    numberLangages = len(langagesPythonList['models'])
    
    for i in range(0, numberLangages):        
        listLangages.append(langagesPythonList['models'][i]['model_id'])    
    
    listLangagesForJson['models']['model_id'] = listLangages
    print(json.dumps(listLangagesForJson))

@app.route('/v2/models', methods=['GET'])
def getLangages():
    resp = make_response(json.dumps(listLangagesForJson), 200)
    resp.mimetype = 'application/json'
    return resp

@app.route('/v2/translate', methods=['POST'])
def translate():
    data = request.get_json()
    if(data['model_id']== "" and data['source'] == "" and data['target']== ""):
        erreurJson = json.dumps('{"error_code":"400", "error_message":"missing required parameter(s)"}')
        print(erreurJson)
        resp = make_response(erreurJson, 400)        
        resp.mimetype = 'application/json'
        return resp
    elif(data['model_id']!= "" or data['source'] == "" or data['target']== ""):
        print("COUCOU")
        translatedText = json.dumps(
        language_translator.translate(data['text'],model_id=data['model_id']), indent=2,
        ensure_ascii=False)
        resp = make_response(translatedText, 200)
        resp.mimetype = 'application/json'
        return resp

    else:    
        print(json.dumps(
        language_translator.translate(data['text'],model_id=data['model_id'], source=data['source'],
                                  target=data['target']), indent=2,
        ensure_ascii=False))

        translatedText = json.dumps(
        language_translator.translate(data['text'],model_id=data['model_id'], source=data['source'],
                                  target=data['target']), indent=2,
        ensure_ascii=False)

        resp = make_response(translatedText, 200)
        resp.mimetype = 'application/json'
        return resp


if __name__ == '__main__':    
    getLangagesAvailable()
    app.run(host='0.0.0.0')
