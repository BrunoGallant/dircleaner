#!/usr/bin/perl -w

# See end of file for documentation

use strict;
use warnings;
use File::Copy;

# Define some variables
my ($toRemove,$toCompress,$toArchive,$dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks,$x_path,$x_seconds,$x_action,$i,$path,@files,$file,$diff,$numberOfFiles);

# Get the arguments
if ( $#ARGV != 5 && $#ARGV != 1 ) {
 print " Usage:\t dircleaner.pl -p <path> -s <difference in seconds> -a [d for delete, c for compress, a for archive, ca for compress and archive] \n";
 exit;
}

for ( $i = 0; $i <= $#ARGV; $i++ ) {
	if ( $ARGV[$i] eq '-p' ) {
		$x_path = $ARGV[$i+1];
	}

	if ( $ARGV[$i] eq '-s' ) {
		$x_seconds = $ARGV[$i+1];
	}
   
	if ( $ARGV[$i] eq '-a' ) {
		$x_action = $ARGV[$i+1];
	}
   
}


#Checking content of $x_action

($toArchive, $toCompress, $toRemove) = 0;

$toRemove = 1 if $x_action eq 'd';
$toArchive = 1 if $x_action eq 'a';
$toCompress = 1 if $x_action eq 'c';
$toArchive = 1 && $toCompress = 1 if $x_action eq 'ca';

# Add a trailing slash if the user did not put it in

$x_path="$x_path/" if not $x_path =~ /\/$/ ;

# Read the files in

opendir DIR, $x_path or die "No such directory!\n";
        @files = readdir DIR or die;
closedir DIR or die;

# Process the files

print "\n";	# Preparing for the pretty print dots
$numberOfFiles=0;

foreach $file (@files) {

        # Skip the special files
        next if $file eq ".";
        next if $file eq "..";
        
        # Skip the directories
        next if (-d $file);

        # Assemble the fully qualified path
        $path="$x_path$file";

        # Get the stats of the file
        ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat $path;

        # Compute the difference since the file's creation time
        $diff = time() - $mtime ;

        # debug line
        #print "\n------------------\nfile=$file, mode=$mode, size=$size, atime=$atime, mtime=$mtime, ctime=$ctime, difference=$diff\n\n";

        
		if ($diff > $x_seconds) {
			if  ($toRemove) {
				&Remove($path);
			}

			if ($toCompress) {
				&Compress($path);
			}

			if ($toArchive) {
				&Archive($path);
			}

		}

	print ".";	# Pretty print dot for each file
	$numberOfFiles++;

}

print "\n\nOperation successful on $numberOfFiles files. \n\n";

sub Remove {
	unlink $path;
#	warn "Deleting $path\n";
	
}

sub Archive {
	mkdir "$x_path/archive" unless (-e "$x_path/archive");
#	print "Archiving $path\n";
	move ("$path.gz", "$x_path/archive") if (-e "$path.gz");
	move ("$path", "$x_path/archive") if (-e "$path");
}

sub Compress {
#	print "Compressing $path\n";
	system ("gzip $path");
}


__END__

=head1 NAME

dircleaner - The directory cleaner

=head1 SYNOPSIS

This program cleans from a determined folder files that are older than
the number of seconds specified on the command line.  They can be deleted,
compressed and/or archived.

=head1 DESCRIPTION

 -p [directory] directory to work on.  Work with or without the trailing
                slash
 -s [seconds]   defines the number of seconds of difference between the
                actual time and the file's mtime
                 
 -a [d,a,c,ca]	action to be taken on the files:
		
		d:	file is deleted.
		a:	file is archived in a directory called archive inside the path.
			If the directory does not exist, it is created
		c:	file is compressed with gzip
		ca:	actions of _c_ and _a_.

=head1 EXAMPLES

To remove all files older than one hour in /tmp:

        dircleaner.pl -p /tmp -s 3600 -a d

To compress and archive files older than one month in /tmp:

	dircleaner.pl -p /tmp -s 2592000 -a ca


=head1 CAVEAT

This script uses the unlink perl function.  If the file has multiple links, it 
will not be deleted elsewhere.

=head1 AUTHOR

 Bruno Gallant -- bgallant@bsdnode.net
 
=head1 VERSION CONTROL
 
$Author: bgallant $
 
$Date: 2013/01/22 20:02:09 $

$Revision: 2.5 $

$State: Exp $

$Log: dircleaner.pl,v $
Revision 2.5  2013/01/22 20:02:09  bgallant
Fixed typos around the code.

Revision 2.4  2013/01/22 19:52:41  bgallant
Added a dot counter and number of files operated on.

Revision 2.3  2013/01/22 19:31:04  bgallant
Using external gzip to compress.


Revision 2.2  2012/06/19 19:18:24  bgallant
Action functions written, basic testing successfull.

Revision 2.1  2012/06/19 15:11:21  bgallant
Main structural changes done.

Revision 2.0  2012/06/19 15:07:15  bgallant
Planning to add
functionality to move files to an archive directory and
compress them.

=cut
