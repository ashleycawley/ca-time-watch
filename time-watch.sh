#!/bin/bash

# Variables
USER="tkeast"
FULLNAME="Thomas Keast"
INSTALLPATH="/home/pi/ca-time-watch" # No trailing slash

# Functions
# Converts seconds in to hours, minutes and seconds like: 07:30:12 
convertsecs() {
	((h=${1}/3600))
	((m=(${1}%3600)/60))
	((s=${1}%60))
	printf "%02d:%02d:%02d\n" $h $m $s
}

# Script

# Creates a folder for the month and year, like: Dec-2018
mkdir -p $INSTALLPATH/`date +%b-%Y`

# Configures the LOGPATH variable to go in this month's folder
LOGPATH=($INSTALLPATH/`date +%b-%Y`)


CHECKEDINLOG=($LOGPATH/$USER-checked-in-on-`date +%d-%m-%Y`)


# Tests to see if the script is already running or not
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]
then

	# Script already running so exiting
	echo "Error: Script already running. Exiting..."
	exit 1

else
	# Checks that the log file does NOT exist
	if [ ! -f $CHECKEDINLOG ]
	then
		# If the file does not exist then it runs the Check-in routine
		touch $CHECKEDINLOG
		echo "`date +%s`" > $CHECKEDINLOG
		
		echo "Check IN - `date` "
	
		exit 0
	else
		# If the file exists it runs the check-out routine and calculate time spent for the day
		
		CHECKOUTTIME=(`date +%s`)
	
		CHECKINTIME=(`cat $CHECKEDINLOG`)
		TIMEWORKED=(`expr $CHECKOUTTIME - $CHECKINTIME`)

		# Logging time worked
		echo $(convertsecs $TIMEWORKED) > "$LOGPATH/$USER time worked on `date +%d-%m-%Y`.log"

		# Displaying time worked
		echo -e "Time worked today: \c"
		cat "$LOGPATH/$USER time worked on `date +%d-%m-%Y`.log"

		# Cleaning up the Check-in log which is no longer needed
		rm -f $CHECKEDINLOG

		exit 0
	fi

fi
