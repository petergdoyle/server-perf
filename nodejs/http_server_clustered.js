
var cluster = require('cluster');
var http = require('http');
var numCPUs = 4;
var COUNTER = 0;
var host = '0.0.0.0';
var port = 5022;
var context='/';

if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) {
        cluster.fork();
    }
} else {
  http.createServer(function (req, res) {
    COUNTER++;
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.write('nodejs: ' + process.argv[1] + '\n');
    res.write('Path: ' + context + '\n');
    res.write('Requests Processed:' + COUNTER+ '\n');
    res.write('Msg: server is running \n');
    res.end();
  }).listen(port, host);
}
