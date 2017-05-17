/**
 * Created by Flavian on 15/05/2017.
 */

let express = require('express');
let app = express();
let qs = require('querystring');
let mysql = require('mysql');


let MongoClient = require('mongodb').MongoClient
    , assert = require('assert');


let parameters = require('../JSON/params.json')

let sql_connection = mysql.createConnection({
    host: parameters.db.host,
    user: parameters.db.user,
    password: parameters.db.password,
    database: parameters.db.database
});


// Connection URL
let url = 'mongodb://' + parameters.mongoDB.host + ':27017/' + parameters.mongoDB.database;
// Use connect method to connect to the Server
MongoClient.connect(url, function (err, db) {
    assert.equal(null, err);
    console.log("Database is up and ready.");
    db.close();
});


let findUsers = function (db, callback) {
    // Get the documents collection
    let users = db.collection('documents');
    // Find some documents
    users.find({}).toArray(function (err, docs) {
        assert.equal(err, null);
        assert.equal(2, docs.length);
        console.log("Found the following records");
        console.dir(docs);
        callback(docs);
    });

};


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
            console.log("Connected correctly to server");
            db.collection('tags').find({}).toArray(function (err, results) {
                assert.equal(err, null);
                console.log("Found the following records");
                response = results;
                console.log(response);
                res.send(response);
            });
            db.close();
        });

    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});

app.post('/checkQrCode', function (req, res) {
    response = null

});


app.get('/getLastPost', function (req, res) {
    response = null;
    try {
        sql_connection.query(
            "SELECT title, content FROM news ORDER BY id DESC LIMIT 1", function (error, results, fields) {
                if (error) throw error;
                console.log(results);
                response = results;
                res.send(response);
            });
    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});


app.get('/getLast10Post', function (req, res) {
    response = null
    try {
        sql_connection.query(
            "SELECT title, content FROM news ORDER BY id DESC LIMIT 10", function (error, results, fields) {
                if (error) throw error;
                console.log(results);
                response = results;
                res.send(response)
            });

    } catch (e) {
        console.log(e);
        res.sendStatus(500)
    }
});


app.get('/post_new', function (req, res) {
    res.sendFile(__dirname + "/post_message.html")
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
        console.log(post)
        try {


            MongoClient.connect(url, function (err, db) {
                assert.equal(null, err);
                console.log("Connected correctly to server");


                db.collection('tags').insertOne(
                    {
                        name: post.name
                    }, function (err, r) {
                        assert.equal(null, err);
                        //assert.equal(1, r.tagCount);
                        console.log("success !")
                    });


                db.collection('tags').find({}).toArray(function (err, docs) {
                    assert.equal(err, null);
                    console.log("Found the following records");
                    console.log(docs)
                });

                db.close();
            });


            sql_connection.query(
                "INSERT INTO tag (id, name) VALUES (NULL,?)", [post.name], function (error, results, fields) {
                    if (error) throw error;
                });
            console.log("Tag added !");
            res.sendStatus(200)
        } catch (e) {
            console.log(e);
            res.sendStatus(500)
        }
    });

});


app.post('/post_new', function (req, res) {
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
            sql_connection.query(
                "INSERT INTO news (id, title, content) VALUES (NULL,?,?)", [post.title, post.content], function (error, results, fields) {
                    if (error) throw error;
                });
            console.log("Post added !");
            res.sendStatus(200);
        } catch (e) {
            console.log(e);
            res.sendStatus(500);
        }
    });

});

app.listen(3000, function () {
    console.log('JO app listening on port 3000!')
});