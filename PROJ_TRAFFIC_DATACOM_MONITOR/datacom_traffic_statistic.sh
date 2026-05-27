#!/bin/bash

# Configurações
ZABBIX_SERVER="172.16.30.113"
ZABBIX_HOST="DATACOM-TRAFEGO-TOTAL"
OUTPUT_DIR="/home/admin/my-setup-ansible/traffic_total_datacom"

# Função para enviar dados para Zabbix
send_to_zabbix() {
    local key="$1"
    local value="$2"

    zabbix_sender -z "$ZABBIX_SERVER" -s "$ZABBIX_HOST" -k "$key" -o "$value"

    if [ $? -eq 0 ]; then
        echo "✓ Enviado: $key = $value"
    else
        echo "✗ Erro ao enviar: $key = $value"
    fi
}

# Processar arquivos
for file in "$OUTPUT_DIR"/*.txt; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        value=$(cat "$file")

        # Extrair IP e informações do nome do arquivo
        # Exemplo: 172.18.254.2_ethernet114_in.txt
        ip=$(echo "$filename" | cut -d'_' -f1)
        interface_info=$(echo "$filename" | cut -d'_' -f2)
        direction=$(echo "$filename" | cut -d'_' -f3 | cut -d'.' -f1)

        # Determinar a chave Zabbix baseada no tipo de interface e direção
        case "$interface_info" in
            ethernet*)
                interface_type="ethernet"
                interface_num=$(echo "$interface_info" | sed 's/ethernet//')
                ;;
            lag*)
                interface_type="lag"
                interface_num=$(echo "$interface_info" | sed 's/lag//')
                ;;
            *)
                interface_type="unknown"
                interface_num=""
                ;;
        esac

        # Construir a chave Zabbix com IP
        if [ -n "$interface_num" ]; then
            zabbix_key="${ip}_traffic.${interface_type}${interface_num}.${direction}.octets"

            echo "Processando: $filename"
            echo "  IP: $ip, Interface: $interface_type$interface_num, Direção: $direction, Valor: $value"
            echo "  Chave Zabbix: $zabbix_key"

            # Enviar para Zabbix
            send_to_zabbix "$zabbix_key" "$value"
            echo "---"
        fi
    fi
done

echo "Processamento concluído!"
