#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
magenta='\033[0;35m'
cyan='\033[0;36m'
BCyan='\033[1;36m'
clear='\033[0m'

interface=$1
re=".{2}:.{2}:.{2}:.{2}:.{2}:.{2}"

#interface=ens33

#First Terminal
solutions(){

echo -e "\n"

read -p "`echo -e ${red}{!}${clear}` If you want `echo -e ${BCyan}solutions${clear}` press (y/n) : " value

if [ ${value} == "y" ] || [ ${value} == "Y" ]; then

    if [[ -z ${mac_address} ]]; then

        echo -e "${cyan}{*}${clear} This is the Mac Address of Attacker :" ${red}${capture_mac_address}${clear}
        echo -e "\n${magenta}{~}${clear} So We are ${red}Blocking${clear} all ARP_replay Coming form this MAC : "${red}${capture_mac_address}${clear}
        echo -e "${red}{~}${clear} If are using ${cyan}linux${clear} machine ${red}RUN${clear} this command !"
        echo -e "\n${cyan}{^}${clear} Ex- arptables -A INPUT --source-mac ${capture_mac_address} -j DROP"
        echo -e "${cyan}{^}${clear} Ex- arptables -A INPUT -s <your gateway_ip> --source-mac ${capture_mac_address} -j DROP"


        echo -e "\n${red}{~}${clear} If are using ${cyan}Windows${clear} ${red}RUN${clear} this command in Powershell !"
        echo -e "\n${cyan}{^}${clear} ${red}RUN${clear} ${cyan}Get-NetAdapter${clear} to get ${yellow}ifIndex${clear} No"
        echo -e "${cyan}[+]${clear} New-NetNeighbor -InterfaceIndex <ifIndex No> -IPAddress 'gateway_ip' -LinkLayerAddress 'gateway_mac'  -State Permanent"
        echo -e "\n\n${red}{!}${clear} If you want to remove this ${yellow}entry${clear} !"
        echo -e "${cyan}[+]${clear} Remove-NetNeighbor -InterfaceIndex 12 -IPAddress gateway_ip "

        kill -9 $xterm_pid

    elif [[ ! -z ${mac_address} && ${mac_address} =~ ${re} ]]; then

        echo -e "{*} This is the Mac Address of Attacker :" ${mac_address}
        echo -e "\n${magenta}{~}${clear} So We are ${red}Blocking${clear} all ARP_replay Coming form this MAC : "${red}${mac_address}${clear}
        echo -e "${red}{~}${clear} If are using ${cyan}linux${clear} machine ${red}RUN${clear} this command !"
        echo -e "\n${cyan}{^}${clear} Ex- arptables -A INPUT --source-mac ${capture_mac_address} -j DROP"
        echo -e "${cyan}{^}${clear} Ex- arptables -A INPUT -s <your gateway_ip> --source-mac ${capture_mac_address} -j DROP"    


        echo -e "\n${red}{~}${clear} If are using ${cyan}Windows${clear} ${red}RUN${clear} this command in Powershell !"
        echo -e "\n${cyan}{^}${clear} ${red}RUN${clear} ${cyan}Get-NetAdapter${clear} to get ${yellow}ifIndex${clear} No"
        echo -e "${cyan}[+]${clear} New-NetNeighbor -InterfaceIndex <ifIndex No> -IPAddress 'gateway_ip' -LinkLayerAddress 'gateway_mac'  -State Permanent"
        echo -e "\n\n${red}{!}${clear} If you want to remove this ${yellow}entry${clear} !"
        echo -e "${cyan}[+]${clear} Remove-NetNeighbor -InterfaceIndex 12 -IPAddress gateway_ip "

        kill -9 $xterm_pid

    fi

else [ ${value} == "n" ] || [ ${value} == "N" ]
        echo -e "Quiting . . .  "
        kill -9 $xterm_pid
        exit 0;
fi

}


xterm -e /bin/bash -l -c "tcpdump -t -i ${interface} arp and 'arp[6:2] == 2' -e" & xterm_pid=$!

echo -e "${cyan}[*]${clear} Press ${BCyan}any${clear} key for further ${yellow}Process${clear} "
read -n 1;

tcpdump -c 2 -t -i ${interface} arp and 'arp[6:2] == 2' > mac.txt 2> /dev/null

# reading mac address 
capture_mac_address=$(cat mac.txt | egrep -o ${re} | sort -u)


echo -e "\n\n${magenta}[?]${clear} This is the mac ${yellow}address${clear} : "${red}${capture_mac_address}${clear}

read -p "`echo -e ${cyan}{^}${clear}` If not then type : [For `echo -e ${BCyan}Default${clear}` press Enter] " mac_address

if [[ -z ${mac_address} ]]; then

    my_subnet=$(ifconfig ${interface} | grep "inet" | grep -v "inet6" | cut -d " " -f 10 | cut -d "." -f 1,2,3)

    if [ -z ${my_subnet} ]; then
        echo "{!} my_subnet varible is empaty. "
        exit;
    fi

    nmap -T4 -sn ${my_subnet}.0/24 > nmap_output

    if [ $? -ne 0 ]; then
        echo "{!} nmap not running properly. "
        exit;
    fi

    attacker_ip=$(cat nmap_output | grep -i ${capture_mac_address} -B2 | grep -iEo "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b")

    echo -e "${magenta}{^}${clear} ${red}Attacket${clear} Ip : "${green}${attacker_ip} ${clear}
    solutions

elif [[ ! -z ${mac_address} && ${mac_address} =~ ${re} ]]; then

    my_subnet=$(ifconfig ${interface} | grep "inet" | grep -v "inet6" | cut -d " " -f 10 | cut -d "." -f 1,2,3)

    if [ -z ${my_subnet} ]; then
        echo "{!} my_subnet varible is empaty. "
        exit;
    fi

    nmap -T4 -sn ${my_subnet}.0/24 > nmap_output

    if [ $? -ne 0 ]; then
        echo "{!} nmap not running properly. "
        exit;
    fi

    attacker_ip=$(cat nmap_output | grep -i ${mac_address} -B2 | grep -iEo "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b")

    echo -e "${magenta}{^}${clear} ${red}Attacket${clear} Ip : "${green}${attacker_ip} ${clear}
    solutions

else
    echo "This is not a mac address"
    exit 0;
fi
