<?php
/**
0. Build todays version of FFmpeg
1. Get list of all files with their absolute paths
2. Insert their path along with the file size to the database
3. Run ffmpeg -i FILE and save the output
4. Save the output to the database without the information ot the FFmpeg build with the current time
**/

/**
CREATE TABLE media_file (
	id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
	path TEXT,
	filesize INTEGER
);
**/

class MediaFFinfo
{
	var $db;
	var $db_file = '';
	var $db_key = '';
	var $db_flags = SQLITE3_OPEN_READWRITE | SQLITE3_OPEN_CREATE;
	
	var ff_path = '';
	var ff_version = '';
	
	function MediaFFinfo()
	{
		print_r(SQLite3::version());
		// versionString, versionNumber
	}
	
	function openDb()
	{
		if ($this->db_file != '')
		{
			$this->db = new SQLite3($this->db_file, $this->$db_flags, $this->db_key);
		}
	}

	function getFFversion()
	{
		exec('ffmpeg --version');
	}
}

// SQLite3 file
$database = '';

echo 'SQLite ' . sqlite_libversion();

$build = 'rev20378';

$values = array();
$link = sqlite_open($database);

$sql = 'INSERT INTO media_file (path, filesize) VALUES ' . implode(', ', $values);




$sql = 'UPDATE media_file SET info = \'' .  . '\', build = \'' . $build . '\' WHERE id = \'' . . '\' LIMIT 1';


