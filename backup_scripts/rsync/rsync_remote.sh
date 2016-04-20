#!/bin/sh
# simple rsync backup script written by farmal.in 2011-01-21
# rewritten by a.shpak 20.04.2016
#
# Contact me at https://github.com/insspb
# latest backup is always in $SDIR/$server/latest folder
# all backups which are older than 7 days would be deleted
# backup.ini file can't contain comments, empty lines and spaces in domain names
#
# example of a GOOD backup.ini:
# server user@mydomain.com:/path/to/public_html
#

SDIR="/backups"
SKEY="$SDIR/.ssh/id_rsa"
SLOG="$SDIR/backup.log"
PID_FILE="$SDIR/backup.pid"
ADMIN_EMAIL="ashpak@ashpak.ru"
INI="$SDIR/backup.ini"
KEEPDAYS="4"

if [ ! -d $SDIR ]; then
	echo "No backup directory, exit"
	exit
fi

if [ ! -e $SKEY ]; then
	echo "No SSH key file, exit"
	exit
fi

if [ ! -e $SINI ]; then
	echo "No ini file, exit"
	exit
fi

if [ -e $PID_FILE ]; then
	if [ -z `ps ax | awk '{ print $1;}' | grep $PID_FILE`]; then
		echo " process $PID_FILE died"
		rm $PID_FILE
	else
		echo " process $PID_FILE still working"
	exit
	fi
fi

touch $PID_FILE

# redirecting all output to logfile
exec >> $SLOG 2>&1

# parsing backup.ini file into $server and $from variables
cat $INI | while read server from ; do
	destination="$SDIR/$server"
	# downloading a fresh copy in 'latest' directory
	echo -e "`date` *** $server backup started">>$SLOG
	# deleting all previous copies which are older than 7 days by creation date, but not 'latest'
	find "$destination" -maxdepth 1 -ctime +$KEEPDAYS -type d -path "$destination" -exec rm -r -f {} \;

	# start counting rsync worktime
	start=$(date +%s)
	rsync -v -r --remove-source-files --one-file-system -e "ssh -i $SKEY" "$from" "$destination" || (echo -e "Error when rsyncing $server. \n\n For more information see $SLOG:\n\n `tail $SLOG`" | mail -s "rsync error" $ADMIN_EMAIL & continue)
	finish=$(date +%s)
	echo -e "`date` *** RSYNC worked for $((finish - start)) seconds">>$SLOG

	echo -e "`date` *** $server backup ended">>$SLOG
	echo -e "`date` *** Total allocated `du -sh $destination | awk '{print $1}'`">>$SLOG
	echo -e "------------------------------------------------------------------">>$SLOG
done

rm $PID_FILE
