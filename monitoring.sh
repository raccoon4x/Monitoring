#!/bin/bash
step=60 #update in seconds
int=`ifconfig | awk 'NR==1{print $1}' | cut -d':' -f1`
echo 'Interface:' $int
url='https://raccoon.weare4x.ru/telegram/drproxy/collect.php'
curl -s -d "register=true" -X POST $url > /dev/null
while true 
do
        prx_bytes=`cat /sys/class/net/${int}/statistics/rx_bytes`
        ptx_bytes=`cat /sys/class/net/${int}/statistics/tx_bytes`
        sleep $step
        uptime=`cat /proc/uptime`
        loadavg=`cat /proc/loadavg`
        rx_bytes=`cat /sys/class/net/${int}/statistics/rx_bytes`
        tx_bytes=`cat /sys/class/net/${int}/statistics/tx_bytes`
        diffrx=$(($rx_bytes - $prx_bytes))
        difftx=$(($tx_bytes - $ptx_bytes))
        rx_speed=$(($diffrx / $step))
        tx_speed=$(($difftx / $step))
        echo "Incoming: ${rx_speed}"
        echo "Outgoing: ${tx_speed}"
        curl -s -d "rx_bytes=${rx_bytes}&tx_bytes=${tx_bytes}&uptime=${uptime}&loadavg=${loadavg}&rx_speed=${rx_speed}&tx_speed=${tx_speed}" -X POST $url > /dev/null
done