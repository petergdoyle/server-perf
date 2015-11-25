
var express = require('express');

var host = '0.0.0.0';
var port = 5020;

var app = express();

app.get('/HelloWorld', function(req, res){
  res.send('hello world\n');
});

app.get('/Echo', function(req, res){
 res.writeHead(200);
 req.on('data',function(message){
   res.write(message);
 });
 req.on('end',function(){
   res.end();
 });
});

app.get('/EchoPipe', function(req, res){
  res
    .on('error', function (err) {
      throw err;
    }) 
    .pipe(res);
});

var server = app.listen(port, host, function() {
  console.log('node.js server listening at http://%s:%s', host, port);
});
