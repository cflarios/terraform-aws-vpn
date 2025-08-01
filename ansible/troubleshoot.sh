#!/bin/bash

# Script de troubleshooting para WireGuard Docker
# Uso: ./troubleshoot.sh <IP_DEL_SERVIDOR>

if [ $# -eq 0 ]; then
    echo "❌ Uso: $0 <IP_DEL_SERVIDOR>"
    exit 1
fi

SERVER_IP=$1

echo "🔍 Troubleshooting WireGuard Docker en $SERVER_IP"
echo "================================================="

echo ""
echo "� Verificando herramientas necesarias en el servidor:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'command -v netstat >/dev/null 2>&1 && echo "✅ netstat disponible" || echo "❌ netstat no encontrado"'

echo ""
echo "�🐳 Estado del contenedor Docker:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker ps | grep wireguard'

echo ""
echo "📋 Logs del contenedor (últimas 20 líneas):"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker logs wireguard --tail 20'

echo ""
echo "📁 Archivos en directorio de configuración:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo find /root/wireguard -type f 2>/dev/null || echo "Directorio no encontrado"'

echo ""
echo "🌐 Verificar puerto 8080:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo netstat -tlnp | grep :8080 || echo "Puerto 8080 no está en uso"'

echo ""
echo "🔥 Estado del firewall:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo ufw status'

echo ""
echo "💾 Espacio en disco:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'df -h'

echo ""
echo "🔧 Comandos útiles:"
echo "Reiniciar contenedor: ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'cd /root/docker-wireguard && sudo docker-compose restart'"
echo "Ver logs en tiempo real: ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker logs wireguard -f'"
echo "Acceder al contenedor: ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker exec -it wireguard bash'"
