#!/bin/sh

stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')

echo "Current status of isc-dhcp-server.service: $stat_old"

if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00" 
then
    echo "VPN is ALIVE FIRST RASP"
elif 
$rasp 
then
    if stat_old=active
	then
        ping -c 5 172.81.0.1
		if ($? -eq 0) 
		then
            echo "VPN is ALIVE AFTER PING"
        else
            echo "Restart VPN AFTER PING"
            killall -15 openvpn
            sleep 5
            /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1

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
        killall -15 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "FULL Restart VPN RASP"
    else
        /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
        sleep 10
        killall -15 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "FULL Restart VPN DHCP"
    
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