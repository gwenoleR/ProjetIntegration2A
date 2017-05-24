var dweetClient = require("node-dweetio");
var dweetio = new dweetClient();
let MongoClient = require('mongodb').MongoClient
    , assert = require('assert');
let url = 'mongodb://soc.catala.ovh:27017/jo';
var request = require('request');

getReaders(launchListening)

function getReaders(callback){
    try {
            MongoClient.connect(url, function (err, db) {
                assert.equal(null, err);
                console.log("Connected correctly to database READ");
                db.collection('readers').find({}).toArray(function (err, results) {
                    assert.equal(err, null);
                    //console.log("Found the following records");
                    readers = results;
                    //console.log(response);
                    db.close();

                    callback(readers)
                });
                
            });
        } catch (e) {
            console.log(e);
        }
}



function launchListening(response){
    for (rep in response){
        reader = response[rep].dweet_id
        dweetio.listen_for(reader, function(dweet){
            newDweet(dweet)
        });
    }
    
}

function newDweet(dweet){
    console.log(dweet)
    var data = {}
    data._id = dweet.content.qrcode.user_id
    data.poi_id = "toto"
    data.inOut = "in"
    console.log(data)
    var pois = []

  
    request('http://gps.soc.catala.ovh/getAllPoi', function (error, response, body) {
        console.log('error:', error); // Print the error if one occurred
        console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received
        console.log('body:', body); // Print the HTML for the Google homepage.
        pois = JSON.parse(body)
    });
    console.log(pois)
    //return "OK"
}
