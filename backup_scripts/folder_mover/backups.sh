#!/bin/bash

VERSION="0.1 (28.11.2015)"
ROOT_UID=0
DESTINATION="/backups"
TIME=`date +"%d-%m-%y"`
DIRECTORYDATE=`date +"%d-%m-%y"`
LOGDIR="/var/log/backuplogs"
LOGFILE=$LOGDIR/"backup-$TIME.log"
KEEPDAYS=30

#Collecting user accounts
USERFOLDERS=`find /home/* -maxdepth 0 -type d`

#Exit codes
E_CLEAN=0
E_NOTROOT=87

#Check for root
if [ "$UID" -ne "$ROOT_UID" ]; then
	echo "Must be root to run this script."
	exit $E_NOTROOT
fi

#Check backup and log folder exist
if [ ! -d "$LOGDIR" ]; then
	mkdir -p "$LOGDIR"
fi

#Creating log
touch $LOGFILE

#Files backup
for SOURCE in $USERFOLDERS; do
	BACKUPUSER=`echo $SOURCE | awk -F "/" '{print $NF}'`
	echo `date +"%d-%m-%y %H:%M:%S"` "================= File backup started for user $BACKUPUSER. =================" >> $LOGFILE
	DESTFILE="$DESTINATION/Users/$BACKUPUSER"

	#Creating folder for user backups
	if [ ! -d "$DESTINATION/Users/$BACKUPUSER" ]; then
		mkdir -p "$DESTINATION/Users/$BACKUPUSER/"
	fi

	#Making backup
	mv $SOURCE/backups/* $DESTFILE 2>1  >> $LOGFILE
	echo `date +"%d-%m-%y %H:%M:%S"` "================= File backup ended for user $BACKUPUSER. =================" >> $LOGFILE
done

#Everytime recheking permissions for backups and logs
chmod 600 $DESTINATION -fR
chmod 600 $LOGDIR -fR

#Deleting old backups
find $DESTINATION -mtime +$KEEPDAYS -exec rm {} -fR \;
find $LOGDIR -type f -mtime +$KEEPDAYS -exec rm {} -fR \;

exit $E_CLEAN
