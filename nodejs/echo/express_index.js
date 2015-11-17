
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!\n');
});

var server = app.listen(5020 , function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('node.js express server listening at http://%s:%s', host, port);
});
