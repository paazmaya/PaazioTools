<?php
// pear install --alldeps php_codesniffer
require_once "PHP/CodeSniffer.php";

$checkDir = 'I:/paazio.nanbudo.fi/public_html';
$standard = 'Zend'; // Zend, PEAR, PHPCS, Squiz and MySource
$extensions = 'php,inc'; // Check only files having php or inc extension

// phpcs --config-set tab_width 4
// phpcs --standard=$standard
// phpcs --extensions=$extensions

$sniff = new PHP_CodeSniffer(1, 4);
?>