#!/bin/bash

# Helper script to configure WireGuard with Docker using Ansible
# Usage: ./deploy.sh [SERVER_IP]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 WireGuard with Docker deployment using Ansible${NC}"
echo "================================================="

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}⚠️  Ansible is not installed${NC}"
    echo -e "${BLUE}🔧 Installing Ansible...${NC}"
    
    # Detect operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt &> /dev/null; then
            # Ubuntu/Debian
            sudo apt update && sudo apt install -y ansible
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            sudo yum install -y epel-release && sudo yum install -y ansible
        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y ansible
        else
            echo -e "${RED}❌ Could not detect package manager${NC}"
            echo -e "${YELLOW}💡 Install Ansible manually: https://docs.ansible.com/ansible/latest/installation_guide/index.html${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install ansible
        else
            echo -e "${RED}❌ Homebrew is not installed${NC}"
            echo -e "${YELLOW}💡 Install Homebrew first: https://brew.sh/${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Unsupported operating system: $OSTYPE${NC}"
        echo -e "${YELLOW}💡 Install Ansible manually: https://docs.ansible.com/ansible/latest/installation_guide/index.html${NC}"
        exit 1
    fi
    
    # Verify installation was successful
    if ! command -v ansible &> /dev/null; then
        echo -e "${RED}❌ Error installing Ansible${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Ansible installed successfully${NC}"
    fi
else
    echo -e "${GREEN}✅ Ansible is already installed${NC}"
fi

# Check if server IP was provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Usage: $0 <SERVER_IP>${NC}"
    echo -e "${YELLOW}💡 Example: $0 54.123.456.789${NC}"
    exit 1
fi

SERVER_IP=$1

# Check that SSH key exists
if [ ! -f ~/.ssh/vpn-server-key ]; then
    echo -e "${RED}❌ SSH key not found at ~/.ssh/vpn-server-key${NC}"
    echo -e "${YELLOW}💡 Run: ssh-keygen -t rsa -b 4096 -f ~/.ssh/vpn-server-key${NC}"
    exit 1
fi

# Create dynamic inventory
echo -e "${BLUE}📝 Configuring inventory...${NC}"
cat > inventory.ini << EOF
[vpn_servers]
vpn-server ansible_host=${SERVER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/vpn-server-key
EOF

echo -e "${GREEN}✅ Inventory configured${NC}"

# Check connectivity
echo -e "${BLUE}🔍 Checking SSH connectivity...${NC}"
if ansible vpn_servers -m ping; then
    echo -e "${GREEN}✅ SSH connectivity OK${NC}"
else
    echo -e "${RED}❌ Cannot connect to server${NC}"
    echo -e "${YELLOW}💡 Verify that:${NC}"
    echo -e "${YELLOW}   - The server IP is correct${NC}"
    echo -e "${YELLOW}   - SSH port (22) is open${NC}"
    echo -e "${YELLOW}   - The SSH key is correct${NC}"
    exit 1
fi

# Execute playbook
echo -e "${BLUE}🚀 Running WireGuard with Docker playbook...${NC}"
ansible-playbook site.yml

echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "${YELLOW}1. Check Docker container:${NC}"
echo "   ssh -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP} 'sudo docker ps'"
echo ""
echo -e "${YELLOW}2. View container logs:${NC}"
echo "   ssh -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP} 'sudo docker logs wireguard'"
echo ""
echo -e "${YELLOW}3. Access configuration web server:${NC}"
echo "   🌐 http://${SERVER_IP}:8080"
echo ""
echo -e "${YELLOW}4. Download specific configuration:${NC}"
echo "   scp -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP}:/root/wireguard/peer1/peer1.conf ."
echo ""
echo -e "${YELLOW}5. View QR code for mobile:${NC}"
echo "   🌐 http://${SERVER_IP}:8080 (look for .png files)"
echo ""
echo -e "${YELLOW}6. Run helper script on server:${NC}"
echo "   ssh -i ~/.ssh/vpn-server-key ubuntu@${SERVER_IP} 'sudo /root/download-configs.sh'"
echo ""
echo -e "${GREEN}🔗 Main URL for downloads: http://${SERVER_IP}:8080${NC}"
