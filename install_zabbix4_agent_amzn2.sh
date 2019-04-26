#!/bin/bash

###############################
# 同じVPCならlocal IPを記載
Z_Server=xx.xx.xx.xx
Z_Metadata=XXX_autoregistration
###############################

# install: agent
rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum install zabbix-agent -y

# configure: agent
zconf="/etc/zabbix/zabbix_agentd.conf"
cp -p ${zconf} ${zconf}.org
cat /dev/null > ${zconf}
echo "PidFile=/var/run/zabbix/zabbix_agentd.pid" >> ${zconf}
echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> ${zconf}
echo "LogFileSize=0" >> ${zconf}
echo "Server=${Z_Server}" >> ${zconf}
echo "ServerActive=${Z_Server}" >> ${zconf}
echo "Hostname=`uname -n`" >> ${zconf}
echo "HostMetadata=${Z_Metadata}" >> ${zconf}
echo "Include=/etc/zabbix/zabbix_agentd.d/*.conf" >> ${zconf}

chkconfig zabbix-agent on
chkconfig --list zabbix-agent
service zabbix-agent start
service zabbix-agent status
