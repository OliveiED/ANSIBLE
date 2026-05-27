#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

set -x


#ps aux | grep ansible-playbook | grep ping_mikrotiks.yml
ps aux | grep ansible-playbook | grep /home/admin/my-setup-ansible/datacom_statistic_traffic.yml

if [ $? == 1 ]
        then
#rm -rf /home/admin/my-setup-ansible/ping_results/*
/usr/bin/ansible-playbook -i /home/admin/my-setup-ansible/hosts_proj_datacom_traffic /home/admin/my-setup-ansible/datacom_statistic_traffic.yml
/home/admin/my-setup-ansible/datacom_traffic_statistic.sh
fi
