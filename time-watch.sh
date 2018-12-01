#!/bin/bash

# is ca-time-watch running already?

# Test to see if script is already running or not
ps aux | grep "script.sh" | grep -v grep 3>/dev/null

if [ `echo $?` == 0 ]
then

	# Script already running so exiting
	echo "Error: Script already running. Exiting..."
	exit 1

else

	find -mtime -1

fi


## Yes
### Then exit

## No 
# Carry on with routine
