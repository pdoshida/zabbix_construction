#!/bin/bash

###############################
# 同じVPCならlocal IPを記載
Z_Server=xx.xx.xx.xx
Z_Metadata=XXX_autoregistration
###############################

# install: agent
rpm -ivh http://repo.zabbix.com/zabbix/4.0/rhel/6/x86_64/zabbix-release-4.0-1.el6.noarch.rpm
yum install zabbix-agent -y

# configure: agent
zconf="/etc/zabbix/zabbix_agentd.conf"
cp -p ${zconf} ${zconf}.org
sed -i -e "s/^Server=127.0.0.1/Server=${Z_Server}/g" ${zconf}
sed -i -e "s/^ServerActive=127.0.0.1/ServerActive=${Z_Server}/g" ${zconf}
sed -i -e "s/^Hostname=Zabbix server/#Hostname=Zabbix server/g" ${zconf}
sed -i -e "s/^# HostnameItem=system.hostname/HostnameItem=system.hostname/g" ${zconf}
sed -i -e "s/^# HostMetadata=/HostMetadata=${Z_Metadata}/g" ${zconf}

chkconfig zabbix-agent on
chkconfig --list zabbix-agent
service zabbix-agent start
service zabbix-agent status
