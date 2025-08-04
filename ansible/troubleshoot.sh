#!/bin/bash

# WireGuard Docker troubleshooting script
# Usage: ./troubleshoot.sh <SERVER_IP>

if [ $# -eq 0 ]; then
    echo "❌ Usage: $0 <SERVER_IP>"
    exit 1
fi

SERVER_IP=$1

echo "🔍 Troubleshooting WireGuard Docker on $SERVER_IP"
echo "================================================="

echo ""
echo "🔧 Checking necessary tools on the server:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'command -v netstat >/dev/null 2>&1 && echo "✅ netstat available" || echo "❌ netstat not found"'

echo ""
echo "🐳 Docker container status:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker ps | grep wireguard'

echo ""
echo "📋 Container logs (last 20 lines):"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker logs wireguard --tail 20'

echo ""
echo "📁 Files in configuration directory:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo find /root/wireguard -type f 2>/dev/null || echo "Directory not found"'

echo ""
echo "🌐 Check port 8080:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo netstat -tlnp | grep :8080 || echo "Port 8080 is not in use"'

echo ""
echo "🔥 Firewall status:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo ufw status'

echo ""
echo "💾 Disk space:"
ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'df -h'

echo ""
echo "🔧 Useful commands:"
echo "Restart container: ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'cd /root/docker-wireguard && sudo docker-compose restart'"
echo "View logs in real time: ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker logs wireguard -f'"
echo "Access container: ssh -i ~/.ssh/vpn-server-key ubuntu@$SERVER_IP 'sudo docker exec -it wireguard bash'"
