date_rasp=$(date +"%Y-%m-%d") # дата rasp
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')
echo "Current status of dnsmasq.service: $stat_new"
echo "Current status of isc-dhcp-server.service: $stat_old"
fmount.sh
echo "Текущая дата Raspberry: ${date_rasp}"
sleep 4

adb_result_formatted=$(adb shell date +"%Y-%m-%d") # переформатирование даты adb в красивый вид
adb_result="${adb_result_formatted}"
echo "Текущая дата ADB: ${adb_result}"
sleep 4
dev1=$(adb devices | grep "device" | awk '{print $2}' | grep "device") # поиск в команде "device"
if [ -z "$dev1" ] # проверка на работоспособность ADB
then
echo "Device ADB no found"
else
pinging=$(adb shell ping -c 5 8.8.8.8)
    if [ $? -ne 0 ] # проверка на пинг ADB
then
echo "Ошибка: Не удалось выполнить пинг." # пинг ADB не идет
break
    fi
exit 0
#if [ "$pinging" >/dev/null 2>&1 ] # проверка на пинг ADB
#echo "$pinging"
#	then
elif
[ "date_rasp"=="adb_result_formatted" ] # проверка на корректность даты из adb в rasp
then
echo "Дата совпадает, выполняю дальше скрипт."
sleep 4
else

# Текущая дата и время с adb shell
adb_result="${adb_result_formatted} $(date +"%T")"
#Извлечь год, месяц, день, часы, минуты и секунды
year=$(echo "$adb_result" | cut -d'-' -f1)
month=$(echo "$adb_result" | cut -d'-' -f2)
day=$(echo "$adb_result" | cut -d'-' -f3 | cut -d' ' -f1)
hour=$(echo "$adb_result" | cut -d' ' -f2 | cut -d':' -f1)
minute=$(echo "$adb_result" | cut -d':' -f2)
second=$(echo "$adb_result" | cut -d':' -f3)

# Сформировать строку с новым форматом
formatted_date="${year}-${month}-${day} ${hour}:${minute}:${second}"

# Установить дату на Raspberry Pi
date -s "${formatted_date}"

# Вывести результат
echo "Дата и время установлены на Raspberry Pi: ${formatted_date}"
#else
#echo "Ошибка: Не удалось выполнить пинг." # пинг ADB не идет
#break
#fi
#exit 0
fi
	
if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
else
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
fi
# Добавлен код для проверки "Initialization Sequence Completed"
while read -r line
 do
    echo "$line"
    if [[ $line==*"Initialization Sequence Completed"* ]]
    then
        echo "Initialization Sequence Completed detected. Exiting the script."
		sleep 2
        break
    fi
	done
	exit 0