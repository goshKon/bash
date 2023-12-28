#!/bin/sh
dhcl=$(grep "/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient" /etc/rc.local)
dhcl_com="# /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient &"
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')

echo "Current status of dnsmasq.service: $stat_new"

if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
    elif
    
[ "$dhcl" != "$dhcl_com" ] 
	then
 			/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
			sleep 10
			killall -15 openvpn
			sleep 5
			/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
			echo "Restarting DHCP"	
   	else
        s1=$(systemctl start dnsmasq.service)
        sleep 10
        echo "Starting dnsmasq.service: $s1"
        sleep 5
        s2=$(systemctl restart dnsmasq.service)
        sleep 10
        echo "Restarting dnsmasq.service: $s2"
        sleep 5
        killall -15 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "Restarting VPN"
		

			
    
fi
# Добавлен код для проверки "Initialization Sequence Completed"
while read -r line
 do
    echo "$line"
    if [ $line == *"Initialization Sequence Completed"* ]
    then
        echo "Initialization Sequence Completed detected. Exiting the script."
		sleep 2
  exit 0
    fi
	done
	exit 0
