# 🐳 Ansible WireGuard Docker Configuration

This directory contains Ansible playbooks to automatically configure a WireGuard VPN server using Docker on your EC2 instance.

## ✨ Features

- **Automatic installation** of Docker and docker-compose
- **WireGuard container** using linuxserver/wireguard image
- **Automatic configuration** of server with public IP
- **Automatic generation** of clients (peers) with QR codes
- **Integrated web server** for easy configuration downloads (port 8080)
- **Configured firewall** (UFW) with security rules
- **No manual configuration** of keys or files required

## � Structure

```
ansible/
├── site.yml                    # Main playbook
├── inventory.ini               # Server inventory
├── ansible.cfg                 # Ansible configuration
├── deploy.sh                   # Automated deploy script
├── group_vars/
│   └── all.yml                 # Global variables
└── roles/
    └── wireguard-docker/
        ├── tasks/              # Docker + WireGuard installation tasks
        ├── templates/          # Templates (docker-compose, scripts)
        └── handlers/           # Service handlers
```

## 🚀 Quick Usage

### 1. Automated Deploy

```bash
# Use deploy script (recommended)
./deploy.sh <SERVER_IP>

# Example:
./deploy.sh 54.123.456.789
```

### 2. Access Configurations

```bash
# Web server for downloads (VERY EASY!)
http://<SERVER_IP>:8080

# Download specific configuration via SCP
scp -i ~/.ssh/vpn-server-key ubuntu@<IP>:/root/wireguard/peer1/peer1.conf .
```

## 📋 Prerequisites

1. **Compatible system**:
   - Linux (Ubuntu/Debian/CentOS/RHEL/Fedora)
   - macOS (with Homebrew)
   - **Ansible will be automatically installed** if not present

2. **SSH key configured**:
   - Must exist at `~/.ssh/vpn-server-key`
   - If it doesn't exist: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/vpn-server-key`

3. **Running EC2 instance**:
   - With Ubuntu 22.04 LTS
   - Ports 22, 80, 443, 51820, 8080 open
   - SSH access configured

## ⚙️ Configuration

### Main variables (group_vars/all.yml)

```yaml
wireguard:
  internal_subnet: "10.13.13.0"    # WireGuard internal network
  server_port: 51820               # WireGuard UDP port
  peers: 3                         # Number of clients to generate
  peer_dns: "auto"                 # DNS for clients
  timezone: "America/Bogota"       # Container timezone

docker:
  compose_version: "2.24.0"        # docker-compose version
```

### Add more clients

1. Edit `group_vars/all.yml`
2. Change the number of peers:
   ```yaml
   peers: 5  # Generate 5 clients instead of 3
   ```
3. Re-run the playbook: `ansible-playbook site.yml`

## 📱 Usage After Deploy

### 🌐 Web Server for Downloads (NEW!)
```bash
# Open in browser
http://<SERVER_IP>:8080

# Lists all configurations with direct downloads
# Includes .conf files for desktop and .png (QR) for mobile
```

### View Docker Container Status
```bash
ssh -i ~/.ssh/vpn-server-key ubuntu@<SERVER_IP> 'sudo docker ps'
ssh -i ~/.ssh/vpn-server-key ubuntu@<SERVER_IP> 'sudo docker logs wireguard'
```

### Download Specific Configuration via SCP
```bash
# List available configurations
ssh -i ~/.ssh/vpn-server-key ubuntu@<SERVER_IP> 'sudo ls /root/wireguard/peer*/'

# Download configuration
scp -i ~/.ssh/vpn-server-key ubuntu@<SERVER_IP>:/root/wireguard/peer1/peer1.conf .
```

### View Help Script
```bash
ssh -i ~/.ssh/vpn-server-key ubuntu@<SERVER_IP> 'sudo /root/download-configs.sh'
```

## 🔧 Client Configuration

### Desktop (Windows/Mac/Linux)
1. Install WireGuard client
2. Go to `http://<SERVER_IP>:8080` and download the `.conf` file
3. Import the `.conf` file in WireGuard
4. Connect

### Mobile (Android/iOS)
1. Install WireGuard app
2. Go to `http://<SERVER_IP>:8080` and download the `.png` file (QR code)
3. In the app, scan the QR code from the downloaded image
4. Connect

## 🔒 Security

The playbook automatically configures:

- **Isolated Docker container** for WireGuard
- **UFW firewall** with specific rules
- **Unique keys** automatically generated by the container
- **Temporary web server** on port 8080 (you can close it later)
- **Automatic NAT** configured by the container

## 🛠️ Troubleshooting

### SSH Connectivity Error
```bash
# Verify detailed connectivity
ansible vpn_servers -m ping -vvv
```

### Docker Container Won't Start
```bash
# Check container logs
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo docker logs wireguard'

# Restart container
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'cd /root/docker-wireguard && sudo docker-compose restart'
```

### Cannot Download Configurations
```bash
# Verify port 8080 is open
# Verify HTTP server is running
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo netstat -tlnp | grep 8080'

# Restart configuration server
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo pkill -f serve-configs.py && cd /root/wireguard && nohup python3 /root/serve-configs.py > /var/log/config-server.log 2>&1 &'
```

### Client Won't Connect
- Verify UDP port 51820 is open in AWS Security Group
- Verify client configuration
- Check container logs: `sudo docker logs wireguard`

## 🔄 Useful Commands

```bash
# View container status
sudo docker ps

# View container logs
sudo docker logs wireguard -f

# Restart WireGuard
cd /root/docker-wireguard && sudo docker-compose restart

# View generated configurations
sudo ls -la /root/wireguard/peer*/

# Verify firewall
sudo ufw status

# Access container (if you need debugging)
sudo docker exec -it wireguard bash
```

## 🌟 Docker Setup Advantages

- ✅ **Faster and more reliable** installation
- ✅ **No manual configuration** of keys or files
- ✅ **Isolation** from host system
- ✅ **Easy updates** of the container
- ✅ **Integrated web server** for downloads
- ✅ **Automatic configuration** of the entire stack
- ✅ **Portability** between different systems
