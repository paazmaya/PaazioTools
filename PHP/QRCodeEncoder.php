<?php
// http://keremerkan.net/php-qr-code-generator/
function QRCodeEncoder($input, $s, $m, $l)
{
  if ( !is_executable("/usr/qrencode/bin/qrencode") )
  {
    header("HTTP/1.1 500 Internal Server Error");
    exit("libqrencode is not installed. Please install it first.");
  }

  if ( empty($input) )
  {
    header("HTTP/1.1 400 Bad Request");
    exit("Input string is empty");
  }

  if ( $s <= 0 )
    $s = 10;

  if ( $m <= 0 )
    $m = 1;

  if ( $l != 'L' && $l != 'M' && $l != 'Q' && $l != 'H' )
    $l = 'L';

  $input = str_replace("%%NEWLINE%%", "\r\n", $input);

  header("Content-Type: image/png");

  passthru("/usr/qrencode/bin/qrencode -s $s -m $m -l $l -o - '" . $input . "'");
}

