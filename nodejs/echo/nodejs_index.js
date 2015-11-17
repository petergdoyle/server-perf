var http = require('http');
var fs = require('fs');
var path = require('path');

var host = '0.0.0.0';
var port = 5020;

http.createServer(function (request, response) {

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

}).listen(port);

console.log('node.js server listening at http://%s:%s', host, port);
