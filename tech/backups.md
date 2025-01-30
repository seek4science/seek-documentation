---
title: Backing up SEEK
redirect_from: "/backups.html"
---


## Backing up the database

You can backup the database using
[mysqldump](https://dev.mysql.com/doc/en/mysqldump.html) using the
following syntax. The database name, username and password follows that which
was used in the install guide - however the username and password should be
different for you if you'd changed them as suggested.

    mysqldump -umysqluser -pmysqlpassword seek_production > seek_production.sql

## Backing up files

The is also no harm in backing up the entire SEEK directory, however the
essential directory to backup it the *filestore/* directory. This is the
directory that contains all asset files, and other potentially important
files.

## Restoring

Should you ever need to restore the database you can do so by logging into
mysql

    mysql -umysqluser -pmysqlpassword

and creating the database (assuming it no longer exists), connecting to it,
and importing the dump:

    >create database seek_production;
    >\r seek_production
    >\. ./seek_production.sql

The files can be restored simply by copying the *filestore/* directory back
into the SEEK root directory.

## Incremental Backups

Incremental backups allow you to recover a particular version of the backup
from a given point in time, depending upon the frequency of the backup and
when the back ups started.

For our own SEEK deployments, we use
[rdiff-backup](http://www.gnu.org/savannah-checkouts/non-gnu/rdiff-backup/)
within a simple script that is run nightly using
[crontab](http://crontab.org/). e.g.

    #!/bin/sh

    logger "Local Rdiff backup started"

    BACKUPDIR=/var/backups/seek
    INCLUDE=/etc/rdiff-backup/backup.include
    EXCLUDE=/etc/rdiff-backup/backup.exclude

    /usr/bin/rdiff-backup --terminal-verbosity 9 --print-statistics --terminal-verbosity 2  --exclude-globbing-filelist $EXCLUDE  --include-globbing-filelist $INCLUDE  --exclude / / $BACKUPDIR

    logger "Local Rdiff backup complete"

where *backup.include* is a file that includes a list of paths (files or
directories) to be backed up, and *backup.exclude* is a list of paths that
should be excluded.

*BACKUPDIR* can also be an ssh url, e.g
*backup@backupserver.co.uk:/var/local/backup/*

