#!/bin/bash

# Copyright (c) 2019 - Younis Amedi < ya@younisamedi.com >
# This script is licensed under GNU GPL version 2.0 or above
#=========================================================================================
#title           : connect_sxp.sh
#description     : This script checks SockeXP status, starts if it's not running and sends port number to a remote server.
#date            : 02 JUNE 2019
#version         : 1.0    
#usage           : connect_sxp.sh
#notes           : Need to SSH into a remote server with keys. www.socketxp.com (Beta)
#bash_version    : 4.1.5(1)-release
#=========================================================================================


######
### Tips: set a cron job as a root user.
### E.g:
### * * * * * /root/scripts/connect_sxp.sh > /dev/null 2>&1
#####

if [[ $EUID -ne 0 ]]; then
echo -e "\n  FAILED: You need to run this as root user.\n"
exit 1
fi

sleep 30

# remote server
RMT_SERVER="USERNAME@SERVER_IP"

# Proxy name / location
PROXY_NAME="NAME_OF_COMPUTER"

# currentIP:
if [ ! -f /tmp/currentIP ]; then
    curl -s ifconfig.me > /tmp/currentIP
fi

if [ ! -f /root/scripts/sxPort_${PROXY_NAME} ]; then
    touch /root/scripts/sxPort_${PROXY_NAME}
fi

if [ ! -f /root/scripts/currIP_${PROXY_NAME} ]; then
    touch /root/scripts/currIP_${PROXY_NAME}    
fi

touch /tmp/LATEST_SOCKETXP_PORT

# Current date
DATE_TIME=$(date)

pgrep -x "socketxp" > /dev/null
echo $? > /tmp/SOCKETXP_STATUS
SX_STATUS=$(cat /tmp/SOCKETXP_STATUS)

## socketxp running status:
function socketStatus {

if [ $SX_STATUS -ne 0 ]; then
   nohup /usr/local/bin/socketxp -connect tcp://localhost:22 | tee /tmp/SOCKETXP_LATEST_${PROXY_NAME} &
   sleep 30
   cp /tmp/SOCKETXP_LATEST_${PROXY_NAME} /root/scripts/sxPort_${PROXY_NAME}
   curl -s ifconfig.me > /tmp/currentIP
   
   echo $DATE_TIME >> /root/scripts/sxPort_${PROXY_NAME}
   cat /tmp/currentIP >> /root/scripts/sxPort_${PROXY_NAME}
   echo -e " \
   " >> /root/scripts/sxPort_${PROXY_NAME}
   
   cp /tmp/currentIP /root/scripts/currIP_${PROXY_NAME}
   ### E.g  path to the remote server: /home/user1/ip_changed/
   scp /root/scripts/sxPort_${PROXY_NAME} ${RMT_SERVER}:/home/user1/ip_changed/
fi

}

socketStatus

exit

### End
