#!/bin/bash

# Variables
USER="tkeast"
FULLNAME="Thomas Keast"
INSTALLPATH="/home/pi/ca-time-watch" # No trailing slash
EPOCH='jan 1 1970'
SUM=0
TOTALLOG="total.log"
oIFS="$IFS"
IFS=$'\n'

# Functions
# Converts seconds in to hours, minutes and seconds like: 07:30:12 
CONVERT_SECONDS_INTO_TIME() {
	((h=${1}/3600))
	((m=(${1}%3600)/60))
	((s=${1}%60))
	printf "%02d:%02d:%02d\n" $h $m $s
}
WAIT() {
	echo "Pausing system for 10 seconds to prevent repeat RFID reads"
	sleep 10
}

# Script

# Creates a folder for the month and year, like: Dec-2018
mkdir -p $INSTALLPATH/`date +%b-%Y`

# Configures the LOGPATH variable to go in this month's folder
LOGPATH=($INSTALLPATH/`date +%b-%Y`)

# Records the temporary log of when staff member checked in
CHECKEDINLOG=($LOGPATH/$USER-checked-in-on-`date +%d-%m-%Y`.log)


# Tests to see if the script is already running or not
( if [[ "`pidof -x $(basename $0) -o %PPID`" ]]
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
	
		WAIT # Pausing system

		exit 0
	else
		# If the file exists it runs the check-out routine and calculate time spent for the day
		
		# Saves the checkout time into variable
		CHECKOUTTIME=(`date +%s`)
	
		# Reads previous check-in time and stores it in a variable
		CHECKINTIME=(`cat $CHECKEDINLOG`)

		# Takes Chekcout Time and subtracts Check In time to get total time worked
		TIMEWORKED=(`expr $CHECKOUTTIME - $CHECKINTIME`)

		# Saves log of time worked
		echo $(CONVERT_SECONDS_INTO_TIME $TIMEWORKED) > $LOGPATH/$USER-`date +%d-%m-%Y`.log

		# Displaying time worked
		echo -e "Time worked today: \c"
		cat $LOGPATH/$USER-`date +%d-%m-%Y`.log

		# Cleaning up the Check-in log which is no longer needed
		rm -f $CHECKEDINLOG

		WAIT # Pausing system

		# Calculating total hours worked on days so far this month and saving to log file
		for i in `cat $USER-*`
		do
			SUM="$(date -u -d "$EPOCH $i" +%s) + $SUM"
		done
		
		# Stores the total number of seconds of all days in a variable
		TOTALSECS=$(echo $SUM|bc)

		# Converts seconds in to easy to comprehend time and saves it to a log
		echo $(CONVERT_SECONDS_INTO_TIME $TOTALSECS) > $LOGPATH/total-hours-so-far.log

		IFS="$oIFS"

		exit 0
	fi

fi ) &
