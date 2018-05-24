const express = require('express');
const path = require('path');
const handlebars = require('express-handlebars');
const bodyParser = require('body-parser');
const Web3 = require('web3');
const Tx = require('ethereumjs-tx');

var app = express();

// app.use(bodyParser.urlencoded({extended:false}));

// app.engine("handlebars", handlebars({defaultLayout: 'main'}));
// app.set('view engine', 'handlebars');


// app.get("/", function(req,res){
//     res.render("home");
// });

// app.post('/submit', function(req,res){
// 	res.render("scSignIn");
// });

app.use(express.static("public"));

app.get("/", function(req,res){
    res.sendFile(__dirname +"/public/html/index.html");
});

app.listen(4500, function(err){
    if(err) console.log(err);
    else console.log("server is up!");
});