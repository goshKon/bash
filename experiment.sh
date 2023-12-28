#!/bin/bash
date_rasp=$(date +"%Y-%m-%d %T")
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')
echo "Current status of dnsmasq.service: $stat_new"
echo "Current status of isc-dhcp-server.service: $stat_old"
fmount.sh
echo "Текущая дата Raspberry: ${date_rasp}"
sleep 4

adb_result_formatted=$(adb shell date +"%Y-%m-%d")
adb_result="${adb_result_formatted} $(date +"%T")"
echo "Текущая дата ADB: ${adb_result}"
sleep 4

if [ "date_rasp" != "adb_result" ]
then
echo "Дата совпадает, выполняю дальше скрипт."
sleep 4
else

# Получить текущую дату и время с adb shell
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
fi
	
if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
#else
 #   ..................................................................................
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
#done < <(/usr/sbin/openvpn --config /etc/openvpn/client.ovpn 2>&1)