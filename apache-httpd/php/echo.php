<?php
$f = @fopen("php://input", "r");
$request_body = stream_get_contents($f);
$response = fopen('php://output', 'w');
while ($buffer =  fread($request_body, 1024)) fwrite($response);
fclose($response);

?>
