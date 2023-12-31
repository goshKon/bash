#!/bin/sh

stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')

echo "Current status of dnsmasq.service: $stat_new"

if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00" 
then
    echo "VPN is ALIVE FIRST ORNG"
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
        killall -15 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "FULL Restart VPN ORNG"
		
	else
			/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
			sleep 10
			killall -15 openvpn
			sleep 5
			/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
			echo "FULL Restart VPN DHCP"	
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