/**
 * Created by Flavian on 15/05/2017.
 */

let express = require('express');
let app = express();
let qs = require('querystring');
let mysql = require('mysql');

let parameters = require('./params.json')

let sql_connection = mysql.createConnection({
    host: parameters.db.host,
    user: parameters.db.user,
    password: parameters.db.password,
    database: parameters.db.database
});


app.get('/getLastPost', function (req, res) {
    response = null
    try {
        sql_connection.query(
            "SELECT title, content FROM news ORDER BY id DESC LIMIT 1", function (error, results, fields) {
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


app.post('/post_new', function (req, res) {
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
            sql_connection.query(
                "INSERT INTO news (id, title, content) VALUES (NULL,?,?)", [post.title, post.content], function (error, results, fields) {
                    if (error) throw error;
                });
            console.log("Post added !")
            res.sendStatus(200)
        } catch (e) {
            console.log(e)
            res.sendStatus(500)
        }
    });

});

app.listen(3000, function () {
    console.log('Example app listening on port 3000!')
});