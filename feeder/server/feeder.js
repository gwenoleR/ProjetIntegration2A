/**
 * Created by Flavian on 15/05/2017.
 */

let express = require('express');
let app = express();
let qs = require('querystring');
let ObjectID = require('mongodb').ObjectID;

let MongoClient = require('mongodb').MongoClient
    , assert = require('assert');


let parameters = require('../JSON/params.json')


// Connection URL
let url = 'mongodb://' + parameters.mongoDB.host + ':27017/' + parameters.mongoDB.database;
// Use connect method to connect to the Server
MongoClient.connect(url, function (err, db) {
    assert.equal(null, err);
    console.log("Database is up and ready.");
    db.close();
});


app.get("/getPostAbout/:tag", function (req, res) {
    console.log(req.params)
    if (req.params.tag == 'sport') {
        res.send([{
            "title": "John is dead :(",
            "content": "John has been found this morning, lying on his fat, greasy belly. His hands were tied to an eletric pylon. NPD director said that it could be a suicide."
        },
            {"title": "Sara is sexy when she runs", "content": "hey its a post about sport and sex"},
            {"title": "laura is sexy when she fucks", "content": "hey its a post about and sport sex"},
        ])
    } else if (req.params.tag == 'sex') {
        res.send([{"title": "John is fuckin", "content": "oh yeah"},
            {"title": "Sara is sexy when she runs", "content": "hey its a post about sport and sex"},
            {"title": "laura is sexy when she fucks", "content": "hey its a post about and sport sex"},
        ])
    }
});


app.get('/getTags', function (req, res) {
    response = null;
    try {
        MongoClient.connect(url, function (err, db) {
            assert.equal(null, err);
            console.log("Getting tgs...");
            db.collection('tags').find({}).toArray(function (err, results) {
                assert.equal(err, null);
                //console.log("Found the following records");
                response = results;
                console.log("done");
                res.send(response);
            });
            db.close();
        });

    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});


app.get('/getLastPost', function (req, res) {
    response = null;
    try {
        MongoClient.connect(url, function (err, db) {
            assert.equal(null, err);
            console.log("Getting the last post...");
            db.collection('posts').find({}).limit(1).sort([['_id', -1]]).toArray(function (err, results) {
                assert.equal(err, null);
                console.log("Found the following records");
                response = results;
                console.log("done");
                res.send(response);
                db.close();
            });
        });
    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});

app.get('/getLastUser', function (req, res) {
    response = null;
    try {
        MongoClient.connect(url, function (err, db) {
            assert.equal(null, err);
            console.log("Connected correctly to server");
            db.collection('user').find({}).limit(1).sort([['_id', -1]]).toArray(function (err, results) {
                assert.equal(err, null);
                console.log("Found the following records");
                response = results;
                console.log(response);
                res.send(response);
                db.close();
            });
        });
    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});


app.get('/tag', function (req, res) {
    post = {
        'title': 'tagTitle',
        'content': 'Hey its a post with some tags',
        'tags': ['sport', 'some', 'sex']
    };
    res.send(post)
});

app.post('/updateTagWeight', function (req, res) {

    body = '';
    post = null;
    req.on('data', function (data) {
        body += data;
        console.log(body)
    });
    //We'll wait the end signal of the request to treat it's content.
    req.on('end', function () {
        post = qs.parse(body);
        //let idUser = new ObjectID(post._id);
        console.log("post request :", post);
        let idToFind = ObjectID(post._id);
        console.log("id : ", idToFind)
        try {
            MongoClient.connect(url, function (err, db) {
                assert.equal(null, err);

                console.log("Connected correctly to server");
                db.collection('user').findOneAndUpdate(
                    {
                        _id: idToFind,
                        "tags.name": post.tag
                    }, {
                        $inc: {"tags.$.weight": 10}
                    }, {
                        returnOriginal: false
                        , upsert: false
                    }, function (err, r) {
                        assert.equal(null, err);
                        if (err) {
                            console.log(err)
                            res.sendStatus(400)
                        }
                        else if (!r.lastErrorObject.updatedExisting) {
                            console.log("tag is not present... Pushing now")
                            db.collection('user').updateOne(
                                {
                                    _id: idToFind
                                }, {
                                    $push: {
                                        "tags": {
                                            "name": post.tag,
                                            "weight": 10
                                        }
                                    }
                                }, {
                                    returnOriginal: false
                                    , upsert: false
                                }, function (err, r) {
                                    assert.equal(null, err);
                                    if (err) {
                                        console.log(err)
                                        res.sendStatus(400)
                                    } else {
                                        console.log(r)
                                        console.log("updated ");

                                    }
                                    db.close();
                                })
                        } else {
                            console.log(r.lastErrorObject.updatedExisting)
                            console.log("updated ");
                            res.sendStatus(201)
                        }
                        db.close();
                    })
            });
        } catch (e) {
            console.log(e);
            res.sendStatus(400)
        }
    });


})


app.get('/getLast10Post', function (req, res) {
    response = null;
    try {
        MongoClient.connect(url, function (err, db) {
            assert.equal(null, err);
            console.log("Connected correctly to server");
            db.collection('posts').find({}).limit(10).sort([['_id', -1]]).toArray(function (err, results) {
                assert.equal(err, null);
                console.log("Found the following records");
                response = results;
                console.log(response);
                res.send(response);
                db.close();
            });
        });
    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});


app.get('/post_new', function (req, res) {
    res.sendFile(__dirname + "/views/post_message.html")
});


app.get('/getUsers', function (req, res) {
    response = null;
    try {
        MongoClient.connect(url, function (err, db) {
            assert.equal(null, err);
            console.log("Connected correctly to server");
            db.collection('user').find({}).toArray(function (err, results) {
                assert.equal(err, null);
                console.log("Found the following records");
                response = results;
                console.log(response);
                res.send(response);
                db.close();
            });
        });
    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});


app.post('/post_new_tag', function (req, res) {
    body = '';
    post = null;
    req.on('data', function (data) {
        body += data;
    });
    //We'll wait the end signal of the request to treat it's content.
    req.on('end', function () {
        post = qs.parse(body);
        console.log(post);
        try {
            MongoClient.connect(url, function (err, db) {
                assert.equal(null, err);

                console.log("Connected correctly to server");
                db.collection('tags').insertOne(
                    {
                        _id: post.name
                    }, function (err, r) {
                        assert.equal(null, err);
                        console.log("success !")
                    });

                db.close();
            });
            console.log("Tag added !");
            res.sendStatus(200)
        } catch (e) {
            console.log(e);
            res.sendStatus(500)
        }
    });

});


function getNextSequenceValue(post) {
    MongoClient.connect(url, function (err, db) {
        assert.equal(null, err);
        let seq = db.collection('counters');
        seq.find({}).toArray(function (err, results) {
            assert.equal(err, null);
            //console.log("Found the following records");
            let sequence = results[0].sequence_value + 1
            insertNewPost(post, sequence)
            seq.findOneAndUpdate({name: "postid"}, {$set: {sequence_value: sequence}}, {
                returnOriginal: true
                , upsert: true
            }, function (err, r) {
                assert.equal(null, err);
            })
        });
    })
}


function insertNewPost(post, sequence) {
    MongoClient.connect(url, function (err, db) {
        assert.equal(null, err);
        console.log("Connected correctly to server");
        db.collection('posts').insertOne(
            {
                _id: sequence,
                title: post.title,
                content: post.content,
                tags: post.tags
            }
            , function (err, r) {
                assert.equal(null, err);
                console.log("success !");
            });
        db.close();
    });
    console.log("Post added !");
}


app.post('/post_new', function (req, res) {
    body = '';
    post = null;
    req.on('data', function (data) {
        body += data;
    });

    //We'll wait the end signal of the request to treat it's content.
    req.on('end', function () {
        //lets clean this body because of the type coecition caused by querystring
        body = body.replace(/%5B%5D/g, "");
        post = qs.parse(body);
        try {
            getNextSequenceValue(post);
            res.sendStatus(200);
        } catch (e) {
            console.log(e);
            res.sendStatus(500);
        }
    });
});


app.post('/saveDest', function (req, res) {

    body = '';
    post = null;
    req.on('data', function (data) {
        body += data;
        console.log(body)
    });
    //We'll wait the end signal of the request to treat it's content.
    req.on('end', function () {


        post = qs.parse(body);
        //let idUser = new ObjectID(post._id);
        console.log("post request :", post);
        let idToFind = ObjectID(post._id);
        console.log("id : ", idToFind)
        try {
            MongoClient.connect(url, function (err, db) {
                assert.equal(null, err);

                console.log("Connected correctly to server");
                db.collection('user').findOneAndUpdate(
                    {
                        _id: idToFind,
                        "dests.label": post.label
                    }, {
                        $inc: {"dests.$.weight": 10}
                    }, {
                        returnOriginal: false
                        , upsert: false
                    }, function (err, r) {
                        assert.equal(null, err);
                        if (err) {
                            console.log(err)
                            res.sendStatus(400)
                        }
                        else if (!r.lastErrorObject.updatedExisting) {
                            console.log("dest is not present... Pushing now")
                            db.collection('user').updateOne(
                                {
                                    _id: idToFind
                                }, {
                                    $push: {
                                        "dests": {
                                            "label": post.label,
                                            "coord": {
                                                "long": post.long,
                                                "lat": post.lat
                                            },
                                            "weight": 10
                                        }
                                    }
                                }, {
                                    returnOriginal: false
                                    , upsert: false
                                }, function (err, r) {
                                    assert.equal(null, err);
                                    if (err) {
                                        console.log(err)
                                        res.sendStatus(400)
                                    } else {
                                        console.log("updated ");
                                        res.sendStatus(201)
                                    }
                                })
                        } else {
                            console.log(r.lastErrorObject.updatedExisting);
                            console.log("updated ");
                            res.sendStatus(201)
                        }
                        db.close();
                    })
            });
        } catch (e) {
            console.log(e);
            res.sendStatus(400)
        }
    });
});


app.listen(3000, function () {
    console.log('JO app listening on port 3000!')
});