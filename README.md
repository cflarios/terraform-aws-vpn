# 🚀 AWS VPN Infrastructure - Terraform & Ansible

Automated infrastructure-as-code solution for deploying a temporary VPN server on AWS using Terraform for infrastructure and Ansible for configuration.

## 🏗️ Architecture Overview

This project creates a complete VPN infrastructure with:
- **Terraform**: Provisions AWS infrastructure (VPC, EC2, Security Groups)
- **Ansible**: Configures WireGuard VPN using Docker containers
- **GitHub Actions**: Automated deployment and destruction workflows
- **AWS Parameter Store**: Secure storage for SSH keys and configurations
- **S3 + DynamoDB**: Remote Terraform state management with locking

## 📁 Project Structure

```
├── 📁 terraform/                    # Infrastructure as Code
│   ├── 📁 modules/                 # Reusable Terraform modules
│   │   ├── 📁 vpc/                # VPC and networking
│   │   ├── 📁 security_group/     # Security group rules
│   │   └── 📁 ec2/                # EC2 instance configuration
│   ├── 📄 main.tf                 # Main Terraform configuration
│   ├── 📄 backend.tf              # S3 backend configuration
│   ├── 📄 variables.tf            # Input variables
│   ├── 📄 outputs.tf              # Output values
│   └── 📄 README.md               # Terraform documentation
├── 📁 ansible/                     # Server Configuration
│   ├── 📁 roles/                  # Ansible roles
│   │   └── 📁 wireguard-docker/   # WireGuard Docker setup
│   ├── 📁 group_vars/             # Group variables
│   ├── 📄 site.yml                # Main playbook
│   └── 📄 inventory.ini           # Inventory file (auto-generated)
├── 📁 .github/workflows/           # CI/CD Automation
│   ├── 📄 cicd_creation.yml       # Deploy infrastructure workflow
│   ├── 📄 cicd_destroy.yml        # Destroy infrastructure workflow
│   └── 📄 README.md               # Workflows documentation
├── 📁 scripts/                     # Utility scripts
│   ├── 📄 setup-backend.sh        # Backend setup script
│   └── 📄 verify-setup.sh         # Configuration verification
├── 📄 SETUP-BACKEND.md            # Setup documentation
└── 📄 LICENSE                     # MIT License
```

## ✨ Features

### 🏗️ Infrastructure (Terraform)
- **VPC**: Small VPC in `us-east-1` region
- **EC2**: Ubuntu 22.04 LTS instance (t3.micro by default)
- **Security Groups**: 
  - Port 22 (SSH)
  - Port 80 (HTTP)
  - Port 443 (HTTPS)
  - Port 8080 (WireGuard config server)
  - Port 51820 (WireGuard VPN)
- **Outputs**: Public IP address for easy access
- **SSH Keys**: Automatically generated and stored securely

### 🔧 Configuration (Ansible)
- **Docker**: Automatic installation of Docker and docker-compose
- **WireGuard**: Containerized using `linuxserver/wireguard` image
- **Peer Generation**: Automatic client configuration generation with QR codes
- **Web Interface**: Built-in web server for downloading configurations (port 8080)
- **Firewall**: UFW firewall properly configured
- **Security**: All configurations stored securely in AWS Parameter Store

### 🚀 GitHub Actions Workflows
- **Deploy Workflow**: Complete infrastructure deployment with one click
- **Destroy Workflow**: Safe infrastructure destruction with confirmation
- **Backend Management**: Automatic S3 backend creation and configuration
- **State Persistence**: Terraform state safely stored in S3 with DynamoDB locking
- **Debugging**: Comprehensive logging and state verification

## � Quick Start

### 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **GitHub Repository** with this code
3. **AWS Credentials** for GitHub Actions

### 🔧 Setup (One-time only)

1. **Configure GitHub Secrets**:
   Go to your repository → Settings → Secrets and variables → Actions
   
   Add these secrets:
   ```
   AWS_ACCESS_KEY_ID=your_access_key
   AWS_SECRET_ACCESS_KEY=your_secret_key
   ```

2. **Required AWS Permissions**:
   Your AWS user needs these policies:
   - `EC2FullAccess`
   - `VPCFullAccess`
   - `S3FullAccess`
   - `DynamoDBFullAccess`
   - `SSMFullAccess`
   - `IAMReadOnlyAccess`

### 🚀 Deploy VPN Infrastructure

1. Go to **Actions** → **"Deploy VPN Infrastructure"**
2. Click **"Run workflow"**
3. Configure options:
   - **Environment**: `dev`, `staging`, or `prod`
   - **Instance Type**: `t3.micro` (cheapest), `t3.small`, `t3.medium`
   - **WireGuard Peers**: Number of VPN clients (e.g., `3`)
4. Click **"Run workflow"**
5. ☕ Wait ~10 minutes for complete deployment

### 📱 Access Your VPN

1. **Web Interface**: Go to `http://INSTANCE_IP:8080`
2. **Download Configurations**:
   - `.conf` files for desktop clients (Windows, macOS, Linux)
   - `.png` files (QR codes) for mobile apps
3. **Import to WireGuard**: Use the official WireGuard app
4. **Connect**: Start using your private VPN!

### 🗑️ Destroy Infrastructure

1. Go to **Actions** → **"Destroy VPN Infrastructure"**
2. Click **"Run workflow"**
3. **IMPORTANT**: Type exactly `DESTROY` in the confirmation field
4. Select the correct environment
5. Click **"Run workflow"**
6. ⏱️ Wait ~5 minutes for complete cleanup
7. 💰 **$0 cost** - all resources destroyed

## 💰 Cost Management

### 💡 Cost Estimates
- **t3.micro**: ~$8.50/month (730 hours)
- **t3.small**: ~$17/month (730 hours)
- **Daily costs**: ~$0.28 (micro) / ~$0.55 (small)

### 🛡️ Cost Protection
- **Automatic Destruction**: Use workflows to avoid leaving resources running
- **Instance Scheduling**: Consider running only when needed
- **Monitoring**: AWS CloudWatch alerts for unexpected costs
- **Budget Alerts**: Set up AWS Budget alerts for your account

## 🔧 Advanced Configuration

### 🎯 Custom Variables
Modify these in your workflow or Terraform variables:

```yaml
# In GitHub Actions workflow
instance_type: "t3.micro"    # t3.micro, t3.small, t3.medium
wireguard_peers: "5"         # Number of VPN clients
environment: "dev"           # dev, staging, prod
```

### 🏗️ Local Development
```bash
# Clone repository
git clone <your-repo>
cd vpn

# Setup backend (one-time)
./scripts/setup-backend.sh

# Deploy locally
cd terraform
terraform init -backend-config="bucket=YOUR_BUCKET" \
               -backend-config="key=YOUR_KEY" \
               -backend-config="region=us-east-1"
terraform plan
terraform apply

# Configure server
cd ../ansible
ansible-playbook -i inventory.ini site.yml
```

## 🐛 Troubleshooting

### 🔍 Common Issues

#### "No changes. No objects need to be destroyed"
This usually means Terraform state issues:
1. Check S3 bucket for state file
2. Verify backend configuration
3. Check debug output in Actions logs

#### SSH Connection Failed
1. Check security group allows port 22
2. Verify SSH key is correctly configured
3. Wait for instance to fully boot (2-3 minutes)

#### WireGuard Not Working
1. Check if Docker containers are running: `docker ps`
2. Verify port 51820 is open in security group
3. Check WireGuard logs: `docker logs wireguard`

### 📊 Debug Information
Both workflows include comprehensive debugging:
- Backend configuration verification
- S3 state file checking
- Security group validation
- Instance status monitoring

### 🆘 Support Resources
- **AWS Documentation**: EC2, VPC, Security Groups
- **WireGuard Documentation**: Official setup guides
- **GitHub Actions**: Workflow debugging guides
- **Terraform Documentation**: State management and backends

## 🔒 Security Best Practices

### 🛡️ Infrastructure Security
- **SSH Keys**: Automatically generated and stored in Parameter Store
- **Security Groups**: Minimal required ports only
- **VPC**: Isolated network environment
- **State Storage**: Encrypted S3 backend with DynamoDB locking

### 🔐 Access Control
- **GitHub Secrets**: Never expose AWS credentials in code
- **Parameter Store**: Encrypted storage for sensitive configuration
- **Time-limited**: Deploy only when needed, destroy when done
- **Monitoring**: CloudTrail logging for all AWS activities

### 🚨 Important Notes
- **Never commit secrets** to Git repository
- **Review costs** regularly in AWS console
- **Monitor access logs** for unusual activity
- **Keep workflows updated** for security patches

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Test your changes thoroughly
4. Submit pull request with detailed description

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: GitHub Discussions for questions and community support
- **Documentation**: Check all README files in subdirectories

## 📚 Additional Documentation

For detailed information about specific components, check these comprehensive guides:

- **🏗️ [Terraform Documentation](./terraform/README.md)**: Infrastructure provisioning, modules, variables, and local development setup
- **🐳 [Ansible Documentation](./ansible/README.md)**: WireGuard Docker configuration, client management, and troubleshooting
- **🚀 [GitHub Actions Documentation](./.github/workflows/README.md)**: CI/CD workflows, deployment automation, cost management, and monitoring

Each component has its own detailed README with:
- Setup instructions
- Configuration options
- Troubleshooting guides
- Best practices
- Advanced usage examples

---

**⚡ Ready to deploy your VPN? Start with the Quick Start guide above!**

---