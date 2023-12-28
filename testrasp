#!/bin/sh

rasp=$(cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)	#Результат 3
if /cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1 == 5 
then
  echo "orange: ${/cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1}"
	#etc/scripts/orange.sh 
else
  echo "rasp: ${/cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1}"
	#etc/scripts/rasp.sh
fi
