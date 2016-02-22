#!/bin/bash
# Sometimes you need to clean postfix queue on mail server 
# This script allow you to work with mail queue with simple interface. 

DATE=`date +"%d-%m-%Y %H:%M:%S"`
QUEUEDIR=`postconf | grep queue_directory | awk '// {print $NF}'`
# Menu options

MAIN_OPTIONS=(
"Postfix management"
"Dovecot management"
"Exim management"
"Postque usage"
"Start all mail services"
"Restart all mail services"
"Stop all mail services"
"Quit"
)

POSTFIX_OPT=(
"Start postfix service"
"Stop postfix service"
"Restart postfix service"
"Main menu"
"Quit"
)

DOVECOT_OPT=(
"Start dovecot service"
"Stop dovecot service"
"Restart dovecot service"
"Main menu"
"Quit"
)

EXIM_OPT=(
"Start exim service"
"Stop exim service"
"Restart exim service"
"Main menu"
"Quit"
)

POSTQUEUE_OPT=(
"Flush mail queue (Try to send all mail)"
"Show first 10 mails in queue"
"Show all mails in queue"
"Show mail content by id"
"Delete all messages by header part"
"Delete all queue"
"Main menu"
"Quit"
)

# Function lists

function quit {
	echo "Thank you for using this script"
	echo "Please contribute at https://github.com/insspb/Bash"
	exit
}

function postfix_management {
	echo "Postfix management menu:"
	select opt in "${POSTFIX_OPT[@]}"; do
		if [ "$opt" = "Quit" ]; then
			quit
		elif [ "$opt" = "Start postfix service" ]; then
			service postfix start
		elif [ "$opt" = "Restart postfix service" ]; then
			service postfix restart
		elif [ "$opt" = "Stop postfix service" ]; then
			service postfix stop
		elif [ "$opt" = "Main menu" ]; then
			clear
			echo "Main menu selected."
			main_menu
		else
			clear
			echo "Wrong option selected"
			echo "Please select again"
			postfix_management
		fi
	done
}

function dovecot_management {
	echo "Dovecot management menu:"
	select opt in "${DOVECOT_OPT[@]}"; do
		if [ "$opt" = "Quit" ]; then
			quit
		elif [ "$opt" = "Start dovecot service" ]; then
			service dovecot start
		elif [ "$opt" = "Restart dovecot service" ]; then
			service dovecot restart
		elif [ "$opt" = "Stop dovecot service" ]; then
			service dovecot stop
		elif [ "$opt" = "Main menu" ]; then
			clear
			echo "Main menu selected."
			main_menu
		else
			clear
			echo "Wrong option selected"
			echo "Please select again"
			dovecot_management
		fi
	done
}

function exim_management {
	echo "Exim management menu:"
	select opt in "${EXIM_OPT[@]}"; do
		if [ "$opt" = "Quit" ]; then
			quit
		elif [ "$opt" = "Start exim service" ]; then
			service exim start
		elif [ "$opt" = "Restart exim service" ]; then
			service exim restart
		elif [ "$opt" = "Stop exim service" ]; then
			service exim stop
		elif [ "$opt" = "Main menu" ]; then
			clear
			echo "Main menu selected."
			main_menu
		else
			clear
			echo "Wrong option selected"
			echo "Please select again"
			exim_management
		fi
	done
}

function postqueue_delete {
	echo "Please enter header info to filter mails:"
	read POST_HEADER
	echo "We reccomend to make dry run of deletion operation. you will get total amount of mesages filtred to deletion by you selection"
	echo "Do you want to spend some time and run dry run? [Y/N]"
	read SELECTOR
		case $SELECTOR in
			[yY]*) echo "We start analyze run of script. No messages will be deleted on this stage. Depends of queue deep and server speed this can be long proccess. Please keep patience."
				MESSAGECOUNT=`find $QUEUEDIR -type f -exec fgrep -q "$POST_HEADER" {} \; -exec basename {} \; |wc -l`
				echo "We found $MESSAGECOUNT messages to delete. Are you sure to delete these messages [Y/N]?"
				echo "WARNING! We done our best to keep you server safe. Nevertheless this script is provided on AS IS basis. We are not responsible for any damage to you server or any data lost. You are running this stage on you own risk!"
				read SELECTOR
					case $SELECTOR in
						[yY]*) find $QUEUEDIR -type f -exec fgrep -q "$POST_HEADER" {} \; -exec basename {} \; | postsuper -d -
							;;
						[nN]*) quit
							;;
						*) echo "Please answer yes or no."
						;;
					esac
				;;
			[nN]*) echo "We do not run dry run. Are you sure to delete messages without any test [Y/N]?"
				echo "WARNING! We done our best to keep you server safe. Nevertheless this script is provided on AS IS basis. We are not responsible for any damage to you server or any data lost. You are running this stage on you own risk!"
				read SELECTOR
					case $SELECTOR in
						[yY]*) find $QUEUEDIR -type f -exec fgrep -q "$POST_HEADER" {} \; -exec basename {} \; | postsuper -d -
							;;
						[nN]*) quit
							;;
						*) echo "Please answer yes or no."
						;;
					esac
				;;
			*) "Please answer yes or no."
			;;
		esac
}

function postfix_queue {
	echo "Postfix queue directory is $QUEUEDIR. Does it looks right? [Y/N]"
	read QQUEUEDIR
		case $QQUEUEDIR in
			[yY]*) postqueue_delete
				;;
			[nN]*) echo "Please enter correct path to queue directory or press ctrl+c to exit"
				read QUEUEDIR
				postfix_queue
				;;
			*) echo "Please answer yes or no."
				postfix_queue
				;;
		esac

}

function postqueue_management {
	echo "Post queue managment menu:"
	select opt in "${POSTQUEUE_OPT[@]}"; do
		if [ "$opt" = "Quit" ]; then
			quit
		elif [ "$opt" = "Main menu" ]; then
			clear
			echo "Main menu selected."
			main_menu
		elif [ "$opt" = "Flush mail queue (Try to send all mail)" ]; then
			postqueue -f
			postqueue_management
		elif [ "$opt" = "Show first 10 mails in queue" ]; then
			echo "Can be long running command. Please wait until menu appear."
			postqueue -p | head -n 31
			postqueue_management
		elif [ "$opt" = "Show all mails in queue" ]; then
			postqueue -p
			postqueue_management
		elif [ "$opt" = "Show mail content by id" ]; then
			echo "Enter message id:"
			read MESSAGEID
			postcat -q $MESSAGEID
			postqueue_management
		elif [ "$opt" = "Delete all messages by header part" ]; then
			postfix_queue
			postqueue_management
		elif [ "$opt" = "Delete all queue" ]; then
			postsuper -d ALL
			postqueue_management
		else
			clear
			echo "Wrong option selected"
			echo "Please select again"
			postqueue_management
		fi
	done
}

function main_menu {
	clear
	echo "To show current menu press Enter in any place."
	echo "Main menu:"
	select opt in "${MAIN_OPTIONS[@]}"; do
		if [ "$opt" = "Quit" ]; then
			quit
		elif [ "$opt" = "Postfix management" ]; then
			postfix_management
		elif [ "$opt" = "Dovecot management" ]; then
			dovecot_management
		elif [ "$opt" = "Exim management" ]; then
			exim_management
		elif [ "$opt" = "Postque usage" ]; then
			postqueue_management
		elif [ "$opt" = "Start all mail services" ]; then
			service dovecot start
			service exim start
			service postfix start
		elif [ "$opt" = "Restart all mail services" ]; then
			service dovecot restart
			service exim restart
			service postfix restart
		elif [ "$opt" = "Stop all mail services" ]; then
			service dovecot stop
			service exim stop
			service postfix stop
		elif [ "$opt" = "Post queue managment" ]; then
			echo test
		else
			clear
			echo "Wrong option selected"
			echo "Please select again"
			main_menu
	fi
done
}

main_menu
