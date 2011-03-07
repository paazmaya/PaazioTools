<?php
// pear install --alldeps pear_info
require_once "PEAR/Info.php";
$info = new PEAR_Info('C:/xampp/php');
$info->display();
?>