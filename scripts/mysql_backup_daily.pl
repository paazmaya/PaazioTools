#!/usr/bin/perl -w

# MySQL database backup script
#
#  Version  1.0  29/04/2005
#
# Jukka Paasonen
# paazio@lulop.org
# http://paazio.nanbudo.fi/

use strict;

# Database username
my $username = "lapponia";

# Database password
my $password = "lapponia";

# Which database you want to back up?
my $database = "lapponia";

# Where in the filesystem should the backups go to?
my $backupdir = "/koira/backups/";

# And to which ftp account they should be sent to?
#my $ftp_addr = "";
#my $ftp_port = "21";
#my $ftp_user = "";
#my #ftp_pass = "";

###################################################
# Don't touch on the last variable here.
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime(time);
$year += 1900;
$mon++;
if ($mon < 10) {
	$mon = "0".$mon;
}
if ($mday < 10) {
	$mday = "0".$mday;
}
my $filename = $backupdir.$database."_".$year."-".$mon."-".$mday.".sql";

system("mysqldump -e --user=$username --password=$password --database \"$database\" > $filename");
system("bzip2 -z9 $filename");
