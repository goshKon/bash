#!/bin/sh

rasp_or_orange=$(cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)	#orange=5, rasp=3.
if [ "$rasp_or_orange" = "5" ]
then  
	echo "Starting orange script"
 	sleep 5
	etc/scripts/orange.sh
 	
else
	echo "Starting rasp script"
 	sleep 5
	etc/scripts/rasp.sh
fi
