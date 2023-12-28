#!/bin/sh
dhcl=$(grep "/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient" /etc/rc.local)
dhcl_com="# /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient &"
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')

echo "Current status of isc-dhcp-server.service: $stat_old"

if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
    elif
    [ "$stat_old" = "active" ]
	then
        pp=$(ping -c 5 172.81.0.1)
		if [ $pp -eq 0 ] 
		then
            echo "Ping successful"
        else
            echo "Reboot VPN"
            killall -15 openvpn
            sleep 5
            /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1

		fi   
fi
    elif 
	[ "$dhcl" != "$dhcl_com" ] 
	then
 /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
        sleep 10
        killall -15 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "FULL Restart VPN DHCP"
	else
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
    
    
# Добавлен код для проверки "Initialization Sequence Completed"
 if grep -q 'Initialization Sequence Completed' "$0"
 then
 echo "tun is work! Exiting the script."
 exit 0
 fi
