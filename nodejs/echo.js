
var http = require('http');

var host = '0.0.0.0';
var port = 5020;

http.createServer(function(request,response){

 response.writeHead(200);
 request.pipe(response);

}).listen(port,host);


console.log('node.js server listening at http://%s:%s', host, port);
