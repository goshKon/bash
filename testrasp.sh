#!/bin/sh

rasp=$(cat /proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)#Результат 3
if [ "rasp"="5" ] 
then
  echo "orange: $rasp"
	#etc/scripts/orange.sh 
else
  echo "rasp: $rasp"
	#etc/scripts/rasp.sh
fi
