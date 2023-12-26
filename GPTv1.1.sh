#!/bin/sh

stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')

echo "Current status of dnsmasq.service: $stat_new"
echo "Current status of isc-dhcp-server.service: $stat_old"

orange=$(cat /proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)	#Результат 5
rasp=$(cat /proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1)	#Результат 3
	if /cat/proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1 == 5 
then  
	$orange 
else
	$rasp 
	fi
if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00" 
then
    echo "VPN is ALIVE FIRST tag"
elif 
$orange 
then
    if stat_new=active||stat_new=inactive 
	then
        s1=$(systemctl start dnsmasq.service)
        sleep 10
        echo "Starting dnsmasq.service: $s1"
        sleep 5
        s2=$(systemctl restart dnsmasq.service)
        sleep 10
        echo "Restarting dnsmasq.service: $s2"
        sleep 5
        killall -9 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "FULL Restart VPN DNS"
		
	else
			/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
			sleep 10
			killall -9 openvpn
			sleep 5
			/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
			echo "1FULL Restart VPN DHCL"	
    fi
elif 
$rasp 
then
    if stat_old=active
	then
        ping -c 5 172.81.0.1
        if ($? -eq 0) 
		then
            echo "VPN is ALIVE NO_FOUND"
        else
            echo "Restart VPN NO_FOUND"
            killall -9 openvpn
            sleep 5
            /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1

            if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
	then
                echo "VPN is ALIVE NO_FOUND2"
            fi
        fi
    elif 
	stat_old=active||stat_old=inactive 
	then
        s3=$(systemctl start isc-dhcp-server.service)
        sleep 10
        echo "Starting isc-dhcp-server.service: $s3"
        sleep 5
        s4=$(systemctl restart isc-dhcp-server.service)
        sleep 10
        echo "Restarting isc-dhcp-server.service: $s4"
        sleep 5
        killall -9 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "FULL Restart VPN ISC"
    else
        /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
        sleep 10
        killall -9 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "2FULL Restart VPN DHCL"
    fi
fi
# Добавлен код для проверки "Initialization Sequence Completed"
while read -r line; do
    echo "$line" 
    if [[ "$line" == *"Initialization Sequence Completed"* ]]
	then
        echo "Initialization Sequence Completed detected. Exiting the script."
        exit 0
    fi
done < <(/usr/sbin/openvpn --config /etc/openvpn/client.ovpn 2>&1)