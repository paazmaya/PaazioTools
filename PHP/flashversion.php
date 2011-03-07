<?php
/**
* Update the Flash version information
* @author Jukka Paasonen
* @see http://paazio.nanbudo.fi/
*/
header('Content-type: text/plain; charset=UTF-8');

/**
* Output values of this file:
* - 0  Version received and row updated
* - 1  Version received, but no row updated
* - 2  Version info not received
* - 3  No Session ID
*
* major, minor, patch, debug. These are the post variables expected.
*/

$msg = 3;

if (isset($_SESSION['id'])) {
	if (isset($_POST['major']) && is_numeric($_POST['major']) && isset($_POST['minor']) && is_numeric($_POST['minor']) && isset($_POST['patch']) && is_numeric($_POST['patch']) && isset($_POST['debug']) && is_numeric($_POST['debug'])) {
		$ver = $_POST['major'].'.'.$_POST['minor'].'.'.$_POST['patch'];
		if ($_POST['debug'] == '1') {
			$ver  .= '_debug';
		}

		$sql = 'UPDATE pz_seslg SET flash=\''.$ver.'\' WHERE seid=\''.$_SESSION['id'].'\' LIMIT 1';
		$run = mysql_query($sql, $link);
		if ($run) {
			if (mysql_affected_rows($link) > 0) {
				$msg = 0;
			}
			else {
				$msg = 1;
			}
		}
	}
	else {
		$msg = 2;
	}
}

echo 'result='.$msg;
?>