# 🚀 GitHub Actions Workflows for VPN

This directory contains GitHub Actions workflows for automated management of temporary VPN infrastructure.

## 📋 Available Workflows

### 1. 🚀 Deploy VPN Infrastructure (`cicd_creation.yml`)
**Purpose**: Deploys complete VPN infrastructure temporarily

**Trigger**: Manual (workflow_dispatch)

**Configurable parameters**:
- **Environment**: Environment name (dev, staging, prod)
- **Instance Type**: EC2 instance type (t3.micro, t3.small, t3.medium)
- **WireGuard Peers**: Number of VPN clients to generate (1-10)

**Process**:
1. 🏗️ **Terraform**: Creates AWS infrastructure (VPC, EC2, Security Groups)
2. 🔑 **SSH Key**: Generates keys automatically
3. ⏳ **Wait**: Waits for instance to be ready
4. 🐳 **Ansible**: Configures Docker + WireGuard
5. 📱 **Configurations**: Generates VPN clients automatically
6. 🌐 **Web Server**: Activates server to download configs (port 8080)

**Outputs**:
- Public IP of the instance
- Configuration web server URL
- SSH access instructions

### 2. 🗑️ Destroy VPN Infrastructure (`cicd_destroy.yml`)
**Purpose**: Completely destroys infrastructure to save costs

**Trigger**: Manual (workflow_dispatch)

**Parameters**:
- **Confirmation**: You must type "DESTROY" to confirm
- **Environment**: Name of environment to destroy

**Process**:
1. ✋ **Validation**: Confirms you really want to destroy
2. 🗑️ **Terraform Destroy**: Removes all AWS resources
3. 🧹 **Cleanup**: Cleans artifacts and temporary data

## 🔧 Initial Setup

### 1. GitHub Secrets
You must configure these secrets in your GitHub repository:

```
Settings → Secrets and variables → Actions → New repository secret
```

**Required secrets**:
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key

### 2. AWS Permissions
Your AWS user must have permissions for:
- EC2 (create/delete instances, security groups, key pairs)
- VPC (create/delete VPCs, subnets, internet gateways)
- S3 (for Terraform state storage)
- DynamoDB (for state locking)
- Systems Manager Parameter Store (for secure storage)

### 3. Repository Permissions
The workflows need:
- `contents: read` - To read the code
- `actions: write` - To manage artifacts
- `id-token: write` - For AWS (if using OIDC)

## 🚀 How to Use

### Deploy VPN (Temporary Use)

1. **Go to GitHub Actions**:
   ```
   Your Repository → Actions → "Deploy VPN Infrastructure"
   ```

2. **Configure parameters**:
   - **Environment**: `dev` (or your preference)
   - **AWS Region**: Choose from available regions (us-east-1, us-west-2, eu-west-1, etc.)
   - **Instance Type**: `t3.micro` (cheapest)
   - **WireGuard Peers**: `3` (number of devices)

3. **Run workflow**:
   - Click "Run workflow"
   - Wait ~5-10 minutes

4. **Get configurations**:
   - When finished, you'll see the public IP in the summary
   - Go to `http://YOUR_PUBLIC_IP:8080`
   - Download `.conf` files for desktop
   - Download `.png` files (QR) for mobile

### Connect Devices

#### Desktop (Windows/Mac/Linux)
1. Install WireGuard client
2. Download `.conf` file from web server
3. Import configuration
4. Connect!

#### Mobile (Android/iOS)
1. Install WireGuard app
2. Download QR image from web server
3. Scan QR from saved image
4. Connect!

### Destroy VPN (Save Costs)

1. **Go to GitHub Actions**:
   ```
   Your Repository → Actions → "Destroy VPN Infrastructure"
   ```

2. **Confirm destruction**:
   - **Confirmation**: Type exactly `DESTROY`
   - **AWS Region**: Must match the region where it was deployed
   - **Environment**: Must match the deployed one

3. **Run workflow**:
   - Click "Run workflow"
   - Wait ~3-5 minutes

4. **Verify**:
   - All AWS resources deleted
   - No more costs

## 💰 Cost Considerations

### EC2 t3.micro Instance
- **Approx cost**: $0.0104/hour (~$0.25/day)
- **Free Tier**: 750 hours free/month for new AWS accounts

### Other Resources
- VPC, Security Groups, Key Pairs: **FREE**
- Data transfer: Minimal for personal VPN

### ⚠️ Important
- **ALWAYS destroy** infrastructure when done
- Use only when you need VPN
- Monitor costs in AWS Console

## 🔄 Typical Workflow

```bash
# Friday night - I need VPN for the weekend
1. GitHub → Actions → "Deploy VPN Infrastructure" → Run
2. Wait 10 minutes
3. Go to http://IP:8080 and download configurations
4. Connect devices
5. Use VPN all weekend

# Monday morning - I don't need VPN anymore
1. GitHub → Actions → "Destroy VPN Infrastructure" 
2. Confirmation: "DESTROY" → Run
3. Wait 5 minutes
4. ✅ No costs until next time
```

## 🛠️ Troubleshooting

### Workflow Fails in Terraform
- Verify AWS secrets are configured
- Check AWS user permissions
- Verify EC2 limits in your region

### Can't Connect to VPN
- Verify you downloaded the correct configuration
- Check that Security Group has port 51820 open
- Verify WireGuard container is running

### Web Server Not Responding
- Verify port 8080 is open in Security Group
- SSH to instance and check: `sudo docker logs wireguard`
- Restart container: `sudo docker-compose restart`

### Unexpected Costs
- Verify you destroyed previous infrastructure
- Check AWS Cost Explorer
- Set up AWS Billing Alerts

## 📊 Monitoring

### GitHub Actions Logs
- Each workflow step is logged
- Important outputs shown in summary
- Errors show specific details

### AWS Logs
- CloudTrail: Change auditing
- EC2 Console: Instance status
- VPC Console: Network configuration

### WireGuard Logs
```bash
# SSH to instance
ssh -i ~/.ssh/vpn-server-key ubuntu@YOUR_IP

# View container logs
sudo docker logs wireguard -f

# View connected clients
sudo docker exec wireguard wg show
```

## 🔒 Security Features

### Infrastructure Security
- **Automatic SSH key generation and storage** in Parameter Store
- **Minimal security group rules** (only required ports)
- **Isolated VPC environment**
- **Encrypted Terraform state** in S3 with DynamoDB locking

### Access Control
- **GitHub Secrets**: No credentials in code
- **Parameter Store**: Encrypted storage for sensitive data
- **Time-limited deployment**: Use only when needed
- **Comprehensive logging**: All actions tracked

## 📈 Advanced Features

### Debugging and Troubleshooting
Both workflows include:
- **Backend configuration verification**
- **S3 state file checking**
- **Security group validation**
- **Instance status monitoring**
- **WireGuard service verification**

### State Management
- **S3 backend**: Secure remote state storage
- **DynamoDB locking**: Prevents concurrent modifications
- **State validation**: Ensures consistency
- **Automatic cleanup**: Removes orphaned resources

### Cost Optimization
- **Automated destruction**: No forgotten resources
- **Instance type selection**: Choose based on needs
- **Monitoring integration**: Track usage and costs
- **Scheduling support**: Deploy only when needed
