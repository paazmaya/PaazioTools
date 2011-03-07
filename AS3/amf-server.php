<?php
$server = new Zend_Amf_Server();
$server->addFunction('loadCollada');
$response = $server->handle();
echo $response;

?>