
BUFFER = new Buffer(10);
on = false;
// // Write a string to a Buffer buf.write( str, // string; A supplied string offset,
// number (optional); The index of the buffer to start writing to (default is 0) length,
// number (optional); The number of bytes to write (defaults to buf.length – offset. encoding
// string (encoding); The encoding to use (defaults to utf8). );
for (var i=0; i<10; i++) {
  var val;
  if (on) {
    BUFFER[i]=49;
  } else {
    BUFFER[i]=48;
  }
  on = !on;
}
console.log('BUFFER.length: ',BUFFER.length,' BUFFER.byteLength:',Buffer.byteLength('BUFFER'));
console.log(BUFFER.toString());

bbuf = new Buffer(26);
for (var i = 0 ; i < 26 ; i++) {
  bbuf[i] = 48;
}
console.log('bbuf: ', bbuf.toString('ascii',0,5));

str = "node.js";
buf = new Buffer(str.length);

for (var i = 0; i < str.length ; i++) {
  buf[i] = str.charCodeAt(i);
}

console.log(buf.slice(0,3).toString());
