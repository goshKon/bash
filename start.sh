#!/bin/sh

orange=$(cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)	#Результат 5
rasp=$(cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)	#Результат 3
if /cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1 == 5 
then  
	etc/scripts/orange.sh 
else
	etc/scripts/rasp.sh
fi
