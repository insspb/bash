#!/bin/bash
#
# VestaCP has issues with MySql down because apache memory consuming. This script monitors both services and restart them on need basis.
#
# For Ubuntu 14.04
#
# Service watchdog script
# Put in crontab to automatially restart services (and optionally email you) if they die for some reason.
# Note: You need to run this as root otherwise you won't be able to restart services.
#

DATE=`date +"%d-%m-%Y %H:%M:%S"`
SERVICE_NAME1="mysqld"
SERVICE_NAME2="apache2"
SERVICE_RESTARTNAME1="mysql"
SERVICE_RESTARTNAME2="apache2"
EXTRA_PGREP_PARAMS="-x" #Extra parameters to pgrep, for example -x is good to do exact matching
MAIL_TO="ashpak@ashpak.ru" #Email to send restart notifications to

#path to pgrep command, for example /usr/bin/pgrep
PGREP="pgrep"

pids1=`$PGREP ${EXTRA_PGREP_PARAMS} ${SERVICE_NAME1}`
pids2=`$PGREP ${EXTRA_PGREP_PARAMS} ${SERVICE_NAME2}`

if [ "$pids1" == "" -o "$pids2" == "" ]
then
	/usr/sbin/service mysql stop
	/usr/sbin/service apache2 stop
	/usr/sbin/service mysql start
	/usr/sbin/service apache2 start
	if [ -z $MAIL_TO ]
		then
			echo "$DATE : Apache and MySQL restarted."
		else
			echo "$DATE : Apache and MySQL restarted. Some service died before." | mail -s "Service failure at $HOSTNAME" $MAIL_TO
	fi
else
	echo "$DATE : Service ${SERVICE_NAME} is still working!"
fi
