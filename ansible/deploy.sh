#!/bin/bash

# Script helper para configurar WireGuard con Docker usando Ansible
# Uso: ./deploy.sh [IP_DEL_SERVIDOR]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}� Deploy de WireGuard con Docker usando Ansible${NC}"
echo "================================================="

# Verificar si Ansible está instalado
if ! command -v ansible &> /dev/null; then
    echo -e "${RED}❌ Ansible no está instalado${NC}"
    echo -e "${YELLOW}💡 Instálalo con: sudo apt install ansible${NC}"
    exit 1
fi

# Verificar si se proporcionó la IP del servidor
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Uso: $0 <IP_DEL_SERVIDOR>${NC}"
    echo -e "${YELLOW}💡 Ejemplo: $0 54.123.456.789${NC}"
    exit 1
fi

SERVER_IP=$1

# Verificar que la clave SSH existe
if [ ! -f ~/.ssh/vpn-server-key ]; then
    echo -e "${RED}❌ Clave SSH no encontrada en ~/.ssh/vpn-server-key${NC}"
    echo -e "${YELLOW}💡 Ejecuta: ssh-keygen -t rsa -b 4096 -f ~/.ssh/vpn-server-key${NC}"
    exit 1
fi

# Crear inventario dinámico
echo -e "${BLUE}📝 Configurando inventario...${NC}"
cat > inventory.ini << EOF
[vpn_servers]
vpn-server ansible_host=${SERVER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/vpn-server-key
EOF

echo -e "${GREEN}✅ Inventario configurado${NC}"

# Verificar conectividad
echo -e "${BLUE}🔍 Verificando conectividad SSH...${NC}"
if ansible vpn_servers -m ping; then
    echo -e "${GREEN}✅ Conectividad SSH OK${NC}"
else
    echo -e "${RED}❌ No se puede conectar al servidor${NC}"
    echo -e "${YELLOW}💡 Verifica que:${NC}"
    echo -e "${YELLOW}   - La IP del servidor es correcta${NC}"
    echo -e "${YELLOW}   - El puerto SSH (22) está abierto${NC}"
    echo -e "${YELLOW}   - La clave SSH es correcta${NC}"
    exit 1
fi

# Ejecutar playbook
echo -e "${BLUE}🚀 Ejecutando playbook de WireGuard con Docker...${NC}"
ansible-playbook site.yml

echo -e "${GREEN}🎉 ¡Deploy completado!${NC}"
echo ""
echo -e "${BLUE}📋 Próximos pasos:${NC}"
echo -e "${YELLOW}1. Verificar contenedor Docker:${NC}"
echo "   ssh -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP} 'sudo docker ps'"
echo ""
echo -e "${YELLOW}2. Ver logs del contenedor:${NC}"
echo "   ssh -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP} 'sudo docker logs wireguard'"
echo ""
echo -e "${YELLOW}3. Acceder al servidor web de configuraciones:${NC}"
echo "   🌐 http://${SERVER_IP}:8080"
echo ""
echo -e "${YELLOW}4. Descargar configuración específica:${NC}"
echo "   scp -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP}:/root/wireguard/peer1/peer1.conf ."
echo ""
echo -e "${YELLOW}5. Ver QR code para móvil:${NC}"
echo "   🌐 http://${SERVER_IP}:8080 (buscar archivos .png)"
echo ""
echo -e "${YELLOW}6. Ejecutar script de ayuda en el servidor:${NC}"
echo "   ssh -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP} 'sudo /root/download-configs.sh'"
echo ""
echo -e "${GREEN}🔗 URL principal para descargas: http://${SERVER_IP}:8080${NC}"
