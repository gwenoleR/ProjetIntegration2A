/**
 * Created by Flavian on 15/05/2017.
 */

let express = require('express')
let app = express()

app.get('/', function (req, res) {
    res.send('Hello World!')
})


app.listen(3000, function () {
    console.log('Example app listening on port 3000!')
})