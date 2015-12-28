#!/bin/bash

VERSION="0.1 (28.11.2015)"
ROOT_UID=0
DESTINATION="/backups"
TIME=`date +"%d-%m-%y"`
DIRECTORYDATE=`date +"%d-%m-%y"`
LOGDIR="/var/log/backuplogs"
LOGFILE=$LOGDIR/"backup-$TIME.log"
MYSQLCFG="/etc/mysql/debian.cnf"
KEEPDAYS=6

#Collecting databases
DATABASES=`mysql --defaults-extra-file=$MYSQLCFG -Bse 'show databases'`

#Collecting user accounts
USERFOLDERS=`find /srv/users/* -maxdepth 0 -type d`

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

if [ ! -d "$DESTINATION/$DIRECTORYDATE/Users" ]; then
	mkdir -p "$DESTINATION/$DIRECTORYDATE"
fi

if [ ! -d "$DESTINATION/$DIRECTORYDATE/Databases" ]; then
	mkdir -p "$DESTINATION/$DIRECTORYDATE"
fi

#Creating log
touch $LOGFILE

#Files backup
for SOURCE in $USERFOLDERS; do
	BACKUPUSER=`echo $SOURCE | awk -F "/" '{print $NF}'`
	echo `date +"%d-%m-%y %H:%M:%S"` "================= File backup started for user $BACKUPUSER. =================" >> $LOGFILE
	DESTFILE="$DESTINATION/$DIRECTORYDATE/Users/$BACKUPUSER/$TIME-$BACKUPUSER"

	#Creating folder for user backups
	if [ ! -d "$DESTINATION/$DIRECTORYDATE/Users/$BACKUPUSER" ]; then
		mkdir -p "$DESTINATION/$DIRECTORYDATE/Users/$BACKUPUSER/"
	fi

	#Making backup
	tar -zcvf "$DESTFILE.tar.gz" $SOURCE 2>&1 >> $LOGFILE
	echo `date +"%d-%m-%y %H:%M:%S"` "================= File backup ended for user $BACKUPUSER. =================" >> $LOGFILE
done

#SQL Backup

for DATABASE in $DATABASES; do
	#Excluding system databases
	if [ "$DATABASE" = "information_schema" -o "$DATABASE" = "performance_schema" -o "$DATABASE" = "mysql" ]; then
		continue
	fi
	#Creating directory
	if [ ! -d "$DESTINATION/$DIRECTORYDATE/Databases/$DATABASE/" ]; then
		mkdir -p "$DESTINATION/$DIRECTORYDATE/Databases/$DATABASE/"
	fi
	#Creating and log SQL backup
	echo `date +"%d-%m-%y %H:%M:%S"` "================= Database $DATABASE backup started. =================" >> $LOGFILE
	mysqldump --defaults-extra-file=$MYSQLCFG $DATABASE | gzip -c > "$DESTINATION/$DIRECTORYDATE/Databases/$DATABASE/$TIME-$DATABASE.dump.gz"
	echo `date +"%d-%m-%y %H:%M:%S"` "================= Database $DATABASE backup ended. =================" >> $LOGFILE
done

#Everytime recheking permissions for backups and logs
chmod 700 $DESTINATION -fR
chmod 700 $LOGDIR -fR

#Deleting old backups
find $DESTINATION -mtime +$KEEPDAYS -exec rm {} -fR \;
find $LOGDIR -type f -mtime +$KEEPDAYS -exec rm {} -fR \;

exit $E_CLEAN
