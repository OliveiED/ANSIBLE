#!/bin/bash

# Caminho para os arquivos de resultados de ping
DIRETORIO="/home/admin/my-setup-ansible"
ZABBIX_SERVER="172.16.30.113"

# Lista os diretórios dos hosts de origem
IPS=$(ls -l "$DIRETORIO/ping_results/" | awk '{print $9}' | grep -v ^$)

for ip in $IPS
do
  for destino in 172.16.101.5 10.10.8.1 172.16.101.23 172.16.101.101
  do
    result_avg_rtt="ping_results/$ip/result_avg-rtt_${destino}.txt"
    result_packet_loss="ping_results/$ip/result_packet-loss_${destino}.txt"

    echo
    echo "--- Processando host $ip para destino $destino ---"
    echo

    # Extraindo o valor de avg_rtt
    set -x
    avg_rtt=$(grep -oP '^\["?\K[0-9]+(?=ms)' "$DIRETORIO/$result_avg_rtt")
    if [[ -z "$avg_rtt" ]]; then
        echo "Erro: Não foi possível extrair avg_rtt de $DIRETORIO/$result_avg_rtt"
        zabbix_sender -z "$ZABBIX_SERVER" -s "$ip" -k "avg_rtt_${destino}" -o "0"
    else
        echo "Valor de avg_rtt (do host $ip para $destino): $avg_rtt"
        zabbix_sender -z "$ZABBIX_SERVER" -s "$ip" -k "avg_rtt_${destino}" -o "$avg_rtt"
    fi
    set +x

    # Extraindo o valor de packet_loss
    packet_loss=$(grep -oP '[0-9]+(?=%)' "$DIRETORIO/$result_packet_loss")
    if [[ -z "$packet_loss" ]]; then
        echo "Erro: Não foi possível extrair packet_loss de $DIRETORIO/$result_packet_loss"
        zabbix_sender -z "$ZABBIX_SERVER" -s "$ip" -k "packet_loss_${destino}" -o "100"
    else
        echo "Valor de packet_loss (do host $ip para $destino): $packet_loss"
        zabbix_sender -z "$ZABBIX_SERVER" -s "$ip" -k "packet_loss_${destino}" -o "$packet_loss"
    fi

  done
done

echo
echo "Fim da segunda etapa -------------------------------------"
echo

