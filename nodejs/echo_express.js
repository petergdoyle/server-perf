
var express = require('express');
var http = require('http');
var fs = require('fs');
var path = require('path');
require('monitor').start();

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


app.get('/EchoStream', function(req, res){
  res
    .on('error', function (err) {
      throw err;
    })
    .pipe(res);
});



app.get('/Retrieve', function(req, res){

	var filePath = '.' + request.url;
	if (filePath == './') {
		filePath = './index.htm';
  }

	var extname = path.extname(filePath);
	var contentType = 'text/plain';

	fs.exists(filePath, function(exists) {

		if (exists) {
			fs.readFile(filePath, function(error, content) {
				if (error) {
					response.writeHead(500);
					response.end();
				}
				else {
					response.writeHead(200, { 'Content-Type': contentType });
					response.end(content, 'utf-8');
				}
			});
		}
		else {
			response.writeHead(404);
			response.end();
		}
	});

});


var server = app.listen(port, host, function() {
  console.log('node.js server listening at http://%s:%s', host, port);
});
