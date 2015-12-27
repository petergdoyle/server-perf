var http = require('http');
var COUNTER = 0;
var host = '0.0.0.0';
var port = 5020;
http.createServer(function (req, res) {
  COUNTER++;
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.write('nodejs: ' + process.argv[1] + '\n');
  res.write('Path: ' + context+ '\n');
  res.write('Requests Processed:' + COUNTER+ '\n');
  res.write('Msg: server is running \n');
  res.end();
}).listen(port, host);
