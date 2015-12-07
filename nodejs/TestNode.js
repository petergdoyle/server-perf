
var express = require('express');
var http = require('http');
var fs = require('fs');
var path = require('path');
require('monitor').start();

/*
Node.js stores raw data in instances of a Buffer class which is similar to an array
of integers but stores raw memory allocations outside the heap.  A Buffer is a
region of a physical memory storage used to temporarily store data while it is being
manipulated. A Buffer class is global in scope, thus not needing a require to use it,
and cannot be resized.
*/
BUF_SIZE = (1024*1000)*5;
BUFFER = new Buffer(BUF_SIZE);
on = false;
// // Write a string to a Buffer buf.write( str, // string; A supplied string offset,
// number (optional); The index of the buffer to start writing to (default is 0) length,
// number (optional); The number of bytes to write (defaults to buf.length – offset. encoding
// string (encoding); The encoding to use (defaults to utf8). );
for (var i=0; i<BUF_SIZE; i++) {
  var val;
  if (on) {
    BUFFER[i]=49;
  } else {
    BUFFER[i]=48;
  }
  on = !on;
}

var host = '0.0.0.0';
var port = 5020;
var app = express();
var context = '/nodejs/';
var COUNTER = 0;

app.get(context, function(req, res){
  COUNTER++;
  var sleepParam = req.param('sleep');
  var sleep = 0;
  if (sleepParam!='undefined') {
     sleep = sleepParam | 0;
  }
  if (sleep > 10000) {
    sleep = 10000;
  }
  res.set('Content-Type', 'text/plain');
  var size = req.param('size');
  if (typeof size !== 'undefined') {
    console.log('size: '+size);
    if (size>BUFFER.length) {
      size = BUFFER.length;
    }
    if (size<0) {
      size = 0;
    }
    setTimeout(function(){
      res.send(BUFFER.slice(0, (size | 0)).toString());
    }, sleep);
    return;
  }
  setTimeout(function(){
    res.write('nodejs: ' + process.argv[1] + '\n');
    res.write('Path: ' + context+ '\n');
    res.write('Requests Processed:' + COUNTER+ '\n');
    res.write('Msg: server is running \n');
    res.end();
  }, sleep);
});

/*
echo whatever is in the body of the message back.
*/
app.post('/', function (req, res) {
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
