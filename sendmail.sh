#!/bin/bash

to=$1
subject=$2
body=$3

cat <<EOF | sendmail -i -F 'Zabbix Alert' "$to"
Subject: $subject

$body
EOF
