#!/bin/bash
# Script para zerar estatísticas de traffic no Zabbix

LOG_FILE="/home/admin/my-setup-ansible/zerar_traffic.log"

echo "==========================================" >> "$LOG_FILE"
echo "$(date): Iniciando zeramento de estatísticas" >> "$LOG_FILE"

zabbix_sender -z 172.16.30.113 -s DATACOM-TRAFEGO-TOTAL -k 172.18.254.2_traffic.ethernet114.in.octets -o "0" && echo "✓ 172.18.254.2 ethernet114 in" >> "$LOG_FILE"
zabbix_sender -z 172.16.30.113 -s DATACOM-TRAFEGO-TOTAL -k 172.18.254.2_traffic.ethernet114.out.octets -o "0" && echo "✓ 172.18.254.2 ethernet114 out" >> "$LOG_FILE"
zabbix_sender -z 172.16.30.113 -s DATACOM-TRAFEGO-TOTAL -k 172.18.254.2_traffic.lag9.in.octets -o "0" && echo "✓ 172.18.254.2 lag9 in" >> "$LOG_FILE"
zabbix_sender -z 172.16.30.113 -s DATACOM-TRAFEGO-TOTAL -k 172.18.254.2_traffic.lag9.out.octets -o "0" && echo "✓ 172.18.254.2 lag9 out" >> "$LOG_FILE"
zabbix_sender -z 172.16.30.113 -s DATACOM-TRAFEGO-TOTAL -k 172.18.254.52_traffic.lag1.in.octets -o "0" && echo "✓ 172.18.254.52 lag1 in" >> "$LOG_FILE"
zabbix_sender -z 172.16.30.113 -s DATACOM-TRAFEGO-TOTAL -k 172.18.254.52_traffic.lag1.out.octets -o "0" && echo "✓ 172.18.254.52 lag1 out" >> "$LOG_FILE"

echo "$(date): Zeramento de estatísticas concluído" >> "$LOG_FILE"
