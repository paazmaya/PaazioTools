<?php

/**
 * @see http://php.net/manual/en/function.error-reporting.php#65049
 * @param int intval
 * @param string $separator
 * @return string
 */
function error_level_tostring($intval, $separator)
{
    $errorlevels = array(		
		1		=> 'E_ERROR',
		2		=> 'E_WARNING',
		4		=> 'E_PARSE',
		8		=> 'E_NOTICE',
		16		=> 'E_CORE_ERROR',
		32		=> 'E_CORE_WARNING',
		64		=> 'E_COMPILE_ERROR',
		128		=> 'E_COMPILE_WARNING',
		256		=> 'E_USER_ERROR',
		512		=> 'E_USER_WARNING',
		1024	=> 'E_USER_NOTICE',
		2048	=> 'E_STRICT',
		4096	=> 'E_RECOVERABLE_ERROR',
		6143	=> 'E_ALL',
		8192	=> 'E_DEPRECATED',
		16384	=> 'E_USER_DEPRECATED'
	);
    $result = '';
    foreach($errorlevels as $number => $name)
    {
        if (($intval & $number) == $number) {
            $result .= ($result != '' ? $separator : '').$name; }
    }
    return $result;
}

