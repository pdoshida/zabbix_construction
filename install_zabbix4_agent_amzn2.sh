#!/bin/bash

###############################
Z_Server=xx.xx.xx.xx
Z_Metadata=XXX_autoregistration
###############################

# install: agent
rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum install zabbix-agent -y

# configure: agent
cp -p /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.org
sed -i -e "s/^Server=127.0.0.1/Server=${Z_Server}/g" /etc/zabbix/zabbix_agentd.conf
sed -i -e "s/^ServerActive=127.0.0.1/ServerActive=${Z_Server}/g" /etc/zabbix/zabbix_agentd.conf
sed -i -e "s/^Hostname=Zabbix server/#Hostname=Zabbix server/g" /etc/zabbix/zabbix_agentd.conf
sed -i -e "s/^# HostnameItem=system.hostname/HostnameItem=system.hostname/g" /etc/zabbix/zabbix_agentd.conf
sed -i -e "s/^# HostMetadata=/HostMetadata=${Z_Metadata}/g" /etc/zabbix/zabbix_agentd.conf

systemctl start zabbix-agent
systemctl enable zabbix-agent
systemctl status zabbix-agent
