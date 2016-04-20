#!/bin/sh
# simple rsync backup script written by farmal.in 2011-01-21
#
# latest backup is always in $SDIR/domains/$domain/latest folder
# all backups which are older than 7 days would be deleted
# backup.ini file can't contain comments, empty lines and spaces in domain names
#
# example of a GOOD backup.ini:
# mydomain.com user@mydomain.com:/path/to/public_html
#

SDIR="/usr/local/backup"
SKEY="$SDIR/.ssh/id_rsa"
SLOG="$SDIR/backup.log"
PID_FILE="$SDIR/backup.pid"
ADMIN_EMAIL="email@domain.com"
INI=backup.ini

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

# parsing backup.ini file into $domain and $from variables
cat $INI | while read domain from ; do
	destination="$SDIR/domains/$domain"
	# downloading a fresh copy in 'latest' directory
	echo -e "`date` *** $domain backup started">>$SLOG

	# start counting rsync worktime
	start=$(date +%s)
	rsync --archive --one-file-system --delete -e "ssh -i $SKEY" "$from" "$destination/latest" || (echo -e "Error when rsyncing $domain. \n\n For more information see $SLOG:\n\n `tail $SLOG`" | mail -s "rsync error" $ADMIN_EMAIL & continue)
	finish=$(date +%s)
	echo -e "`date` *** RSYNC worked for $((finish - start)) seconds">>$SLOG

    # cloning the fresh copy by hardlinking
	cp --archive --link "$destination/latest" "$destination/`date +%F`"
	# deleting all previous copies which are older than 7 days by creation date, but not 'latest'
	find "$destination" -maxdepth 1 -ctime +7 -type d -path "$destination/????-??-??" -exec rm -r -f {} \;
	echo "`date` *** The size of $domain/latest is now `du -sh $destination/latest | awk '{print $1}'` ">>$SLOG
	echo -e "`date` *** $domain backup ended">>$SLOG
	echo -e "`date` *** Total allocated `du -sh $destination | awk '{print $1}'`">>$SLOG
	echo -e "------------------------------------------------------------------">>$SLOG
done

rm $PID_FILE
