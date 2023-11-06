#!/usr/bin/env python
#
# Remove files quickly from a directory. You can compress or archive them also instead.
#
#

import os,sys,optparse,time,shutil,gzip

def mkArchiveDir():
    if not (os.path.exists(archivepath)):
        os.mkdir(archivepath)

def delete(x):
    os.unlink(x)

def archive(x):
    mkArchiveDir()
    shutil.move(x, archivepath)
    print("a")

def compress(x):
    mkArchiveDir()
    in_data = open(x, "rb").read()
    out_gz = archivepath + x + ".gz"
    gzf = gzip.open(out_gz, "wb")
    gzf.write(in_data)
    gzf.close()
    delete(x)

def main():
    parser = optparse.OptionParser('[-] Usage: dircleaner.py '+ '-p <PATH> -s <SECONDS> -a <ACTION>')
    parser.add_option('-p', dest='path', type='string', help='work path')
    parser.add_option('-s', dest='seconds', type='int', help='number of seconds in the past since now')
    parser.add_option('-a', dest='action', type='string', help='a = archive, ca = compress and archive, d = delete files')
    (options, args) = parser.parse_args()

    if (options.path == None) | (options.seconds == None) | (options.action == None):
        sys.exit(parser.usage)

    path = options.path
    seconds = options.seconds
    action = options.action

    global archivepath
    archivepath = path + "archive/"

    if (action != "a") & (action != "d") & (action != "ca"):
        sys.exit("Valid actions are:\n\na = archive, ca = compress and archive, d = delete files\n\nInsert coin and try again! ")

    now = int(time.time())
    files = os.listdir(path)
    os.chdir(path)

    for a in files:
        if os.path.isfile(a):
            stat = os.stat(a)
            ctime = int(stat.st_ctime)
            diff = now - ctime
            if diff > seconds:
                if action == "a":
                    archive(a)
                elif action =="ca":
                    compress(a)
                elif action == "d":
                    delete(a)

####################################################################

if __name__ == '__main__':
    main()
