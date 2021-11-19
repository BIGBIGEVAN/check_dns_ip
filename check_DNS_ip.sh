#!/bin/bash -xv

function check_DNS_ip(){
    DNS_record="192.168.0.101"
    host_ip=$(hostname -I | awk '{print $1}')
    if [ $DNS_record != $host_ip ]
    then
	    sudo sed -i.bak "/static ip_address=/ s/$host_ip/$DNS_record/g" /etc/dhcpcd.conf
	    echo "updated conf file"
            sudo ifconfig wlan0 down && sleep 5 && sudo ifconfig wlan0 up
	    sleep 30
	    ping -c 1  -w 2 $DNS_record >/dev/null
	    if [ $? -eq 0 ]
	    then 
		    echo "updated DNS ip address"
	    else 
	            sudo rm /etc/dhcpcd.conf
	            sudo mv /etc/dhcpcd.conf.bak /etc/dhcpcd.conf
	            sudo ifconfig wlan0 down && sleep 5 && sudo ifconfig wlan0 up
	            echo "changed back to .bak file"
	   fi
    fi	   
	    
}

check_DNS_ip
