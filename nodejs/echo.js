
var http = require('http');
require('monitor').start();

var host = '0.0.0.0';
var port = 5020;

http.createServer(function(request,response){

 response.writeHead(200);

 request.on('data',function(message){
   response.write(message);
 });

 request.on('end',function(){
   response.end();
 });

}).listen(port,host);


console.log('node.js server listening at http://%s:%s', host, port);
