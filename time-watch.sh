#!/bin/bash

# Variables
USER="tkeast"
FULLNAME="Thomas Keast"
INSTALLPATH="/home/pi/ca-time-watch" # No trailing slash

TODAYSLOG=($INSTALLPATH/log/$USER-`date +%Y-%m-%d`)


# Script

# Test to see if script is already running or not
ps aux | grep "script.sh" | grep -v grep 3>/dev/null

if [ `echo $?` == 0 ]
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
	else
		# If the file exists it runs the check-out routine and calculate time spent for the day
		echo "The log file: $USER-`date +%Y-%m-%d` exists"
	fi

fi


## Yes
### Then exit

## No 
# Carry on with routine
