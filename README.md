NAME

dircleaner - The directory cleaner

SYNOPSIS

This program cleans from a determined folder files that are older than
the number of seconds specified on the command line.  They can be deleted,
compressed and/or archived.

DESCRIPTION

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

EXAMPLES

To remove all files older than one hour in /tmp:

        dircleaner.pl -p /tmp -s 3600 -a d

To compress and archive files older than one month in /tmp:

	dircleaner.pl -p /tmp -s 2592000 -a ca


CAVEAT

This script uses the unlink perl function.  If the file has multiple links, it 
will not be deleted elsewhere.

AUTHOR

 Bruno Gallant -- bgallant@bsdnode.net
 
ORIGINAL RCS VERSION CONTROL
 
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
