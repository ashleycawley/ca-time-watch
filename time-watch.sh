#!/bin/bash

# Variables
USER="tkeast"
FULLNAME="Thomas Keast"
INSTALLPATH="/home/pi/ca-time-watch" # No trailing slash

TODAYSLOG=($INSTALLPATH/log/$USER-`date +%Y-%m-%d`)

# Functions
convertsecs() {
	((h=${1}/3600))
	((m=(${1}%3600)/60))
	((s=${1}%60))
	printf "%02d:%02d:%02d\n" $h $m $s
}

# Script

# Test to see if script is already running or not
ps aux | grep "time-watch.sh" | grep -v grep 3>/dev/null

# Tests to see if the script is already running or not
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]
then

	# Script already running so exiting
	echo "Error: Script already running. Exiting..."
	exit 1

else
	# Checks that the log file does NOT exist
	if [ ! -f $TODAYSLOG ]
	then
		# If the file does not exist then it runs the Check-in routine
		touch $TODAYSLOG
		echo "`date +%s`" > $TODAYSLOG
		
		echo "Check IN - `date` "
		echo && echo "Pausing..." && sleep 5
		exit 0
	else
		# If the file exists it runs the check-out routine and calculate time spent for the day
		
		CHECKOUTTIME=(`date +%s`)
	
		CHECKINTIME=(`cat $TODAYSLOG`)
		TIME=(`expr $CHECKOUTTIME - $CHECKINTIME`)

		# Logging time worked
		echo $(convertsecs $TIME) > $INSTALLPATH/log/$USER-time-worked.log

		# Displaying time worked
		echo "Time worked today:"
		cat $INSTALLPATH/log/$USER-time-worked.log

		echo && echo "Pausing..." && sleep 5

		exit 0
	fi

fi
