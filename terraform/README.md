# 🏗️ Terraform AWS VPN Infrastructure

This Terraform project creates a basic AWS infrastructure for a VPN server with the following components:

## 📦 Resources Created

- **VPC**: Small VPC in `us-east-1` region
- **Public Subnet**: With Internet Gateway
- **Security Group**: With enabled ports:
  - 22 (SSH)
  - 80 (HTTP)  
  - 443 (HTTPS)
  - 8080 (WireGuard configuration server)
  - 51820 (WireGuard VPN)
- **EC2 Instance**: Ubuntu 22.04 LTS

## 📁 Project Structure

```
terraform/
├── main.tf                     # Main configuration
├── variables.tf                # Input variables
├── outputs.tf                  # Output values
├── backend.tf                  # S3 backend configuration
├── terraform.tfvars.example    # Configuration example
└── modules/
    ├── vpc/                    # Network module
    ├── security_group/         # Security module
    └── ec2/                    # Instance module
```

## 📋 Prerequisites

1. **AWS CLI** configured with valid credentials
2. **Terraform** installed (version >= 1.5.0)
3. **SSH key** support (automatically managed via variables or files)

## 🚀 Usage

### 1. Generate SSH Key (if not using variables)

```bash
# The project expects an SSH key at ~/.ssh/vpn-server-key
# If it doesn't exist, you can generate it with:
ssh-keygen -t rsa -b 4096 -f ~/.ssh/vpn-server-key -N "" -C "vpn-server-key"
```

### 2. Configure variables

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit variables according to your needs
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the deployment

```bash
terraform plan
```

### 5. Apply the configuration

```bash
terraform apply
```

### 6. View outputs

```bash
terraform output
```

## 📊 Important Outputs

- **instance_public_ip**: Public IP address of the instance
- **ssh_connection_command**: Complete command to connect via SSH
- **key_pair_name**: Name of the key pair created in AWS
- **instance_public_dns**: Public DNS of the instance

## ✅ Verify Deployment

Once the configuration is applied, you can verify everything works:

```bash
# View public IP
terraform output instance_public_ip

# View complete SSH command
terraform output ssh_connection_command

# Connect via SSH using the generated key
ssh -i ~/.ssh/vpn-server-key ubuntu@$(terraform output -raw instance_public_ip)
```

## 🧹 Clean Up Resources

To delete all created resources:

```bash
terraform destroy
```

## ⚙️ Customization

You can modify variables in `terraform.tfvars` to:

- Change instance type
- Modify IP ranges
- Use different availability zones
- Change environment name

**Note**: SSH key is automatically read from `~/.ssh/vpn-server-key.pub` or can be provided via variables

## 🔒 Security

⚠️ **Important**: This setup opens ports to the entire Internet (0.0.0.0/0). For production, consider:

- Restricting SSH access to specific IPs
- Using a bastion host
- Implementing additional authentication
- Configuring monitoring and logging
