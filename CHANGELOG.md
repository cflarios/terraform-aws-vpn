# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 🔧 Fixed
- Fixed SSH key file evaluation error in destroy workflows that prevented infrastructure cleanup
- Enhanced all destroy workflows to retrieve SSH public keys from AWS Parameter Store during execution
- Simplified Terraform SSH key resource configuration to prevent conditional file() evaluation issues
- Added consistent AWS region variable passing in all workflow steps

## [2.0.0] - 2025-08-03

### 🌍 Added - Multi-Region Support
- **Multi-Region Deployment Workflow** (`cicd_multi_region.yml`)
  - Deploy VPN servers across multiple AWS regions simultaneously
  - Support for up to 5 parallel region deployments
  - Region validation and parsing from comma-separated input
  - Independent infrastructure per region (VPC, EC2, SSH keys, backends)
  
- **Multi-Region Destroy Workflow** (`cicd_multi_region_destroy.yml`)
  - Auto-discovery of deployed regions with `all` option
  - Parallel destruction across multiple regions
  - Complete cleanup of all resources, state, and configuration
  - Safety confirmation with `DESTROY-ALL` requirement

- **Global Region Support**
  - US regions: us-east-1, us-east-2, us-west-1, us-west-2
  - Europe regions: eu-west-1, eu-west-2, eu-central-1
  - Asia Pacific regions: ap-southeast-1, ap-southeast-2, ap-northeast-1

### 🔧 Enhanced - Single Region Features
- **Dynamic Region Selection** in single-region workflows
  - Configurable AWS region parameter in both deploy and destroy workflows
  - Automatic availability zone selection based on chosen region
  - Updated Terraform variables for flexible region deployment

### 📚 Documentation
- **Comprehensive README Updates**
  - Multi-region deployment instructions
  - Global cost estimates and examples
  - Regional selection strategies
  - Updated project structure with multi-region workflows

- **Enhanced Workflow Documentation**
  - Complete documentation for all 4 workflows
  - Multi-region usage examples
  - Best practices and cost considerations

### 🏗️ Infrastructure Improvements
- **Enhanced VPC Module**
  - Dynamic availability zone selection using data sources
  - Flexible AZ configuration when not explicitly specified
  
- **Improved Backend Management**
  - Region-specific S3 buckets and DynamoDB tables for multi-region
  - Independent state management per region
  - Enhanced backend configuration validation

## [1.1.0] - 2025-08-02

### 🌐 Added - Internationalization
- **Complete English Translation**
  - Translated all Spanish documentation to English
  - Updated Terraform variables comments
  - Translated Ansible role documentation
  - Updated GitHub Actions workflow documentation

### 📄 Added - Licensing
- **MIT License** 
  - Added standard MIT License file
  - Updated README with license information
  - Professional open-source licensing

### 📁 Enhanced - Documentation Structure
- **Cross-Referenced Documentation**
  - Main README references component-specific READMEs
  - Comprehensive documentation for Terraform, Ansible, and workflows
  - Professional project presentation

## [1.0.0] - 2025-08-01

### 🎉 Initial Release

### 🏗️ Added - Core Infrastructure
- **Terraform Infrastructure as Code**
  - Modular Terraform setup with VPC, Security Group, and EC2 modules
  - AWS provider configuration with S3 remote state backend
  - DynamoDB state locking for concurrent safety
  - Ubuntu 22.04 LTS EC2 instances with configurable types

### 🐳 Added - WireGuard Configuration
- **Ansible Automation**
  - Dockerized WireGuard setup using linuxserver/wireguard image
  - Automatic peer configuration generation with QR codes
  - Built-in web server for configuration downloads (port 8080)
  - UFW firewall configuration

### 🚀 Added - CI/CD Automation
- **GitHub Actions Workflows**
  - `cicd_creation.yml`: Complete VPN infrastructure deployment
  - `cicd_destroy.yml`: Safe infrastructure destruction
  - Automatic SSH key generation and secure storage in AWS Parameter Store
  - Comprehensive debugging and state verification

### 🔒 Added - Security Features
- **Secure Key Management**
  - Automatic SSH key generation per deployment
  - Encrypted storage in AWS Systems Manager Parameter Store
  - Per-environment key isolation

- **Network Security**
  - Security groups with minimal required ports (22, 80, 443, 8080, 51820)
  - VPC isolation with dedicated subnets
  - UFW firewall configuration on instances

### 🔧 Added - Backend Management
- **Terraform Backend Setup**
  - Automatic S3 bucket creation with versioning and encryption
  - DynamoDB table creation for state locking
  - Backend configuration parameter storage
  - Setup scripts for backend initialization (`setup-backend.sh`)

### 📊 Added - Monitoring & Debugging
- **Comprehensive Logging**
  - Backend configuration verification
  - S3 state file validation
  - Infrastructure deployment status tracking
  - WireGuard service monitoring

### 💰 Added - Cost Management
- **Cost Optimization Features**
  - Temporary infrastructure deployment model
  - Automatic resource cleanup workflows
  - Cost estimates and monitoring guidance
  - Instance type selection (t3.micro, t3.small, t3.medium)

### 🔧 Added - Configuration Management
- **Flexible Configuration**
  - Environment-based deployments (dev, staging, prod)
  - Configurable WireGuard peer counts
  - Instance type selection via workflow parameters
  - Automated inventory generation for Ansible

### 📱 Added - Client Support
- **Multi-Platform Client Support**
  - Desktop clients: .conf file generation for Windows, macOS, Linux
  - Mobile clients: QR code generation for Android and iOS
  - Web-based configuration download interface
  - Automatic peer certificate generation

### 🛠️ Added - Development Tools
- **Setup and Verification Scripts**
  - Backend setup automation (`setup-backend.sh`)
  - Configuration verification tools
  - Deployment validation scripts

---

## Version History Summary

- **v2.0.0**: Multi-region support with global VPN deployment capabilities
- **v1.1.0**: Complete English documentation and MIT licensing
- **v1.0.0**: Initial release with core VPN infrastructure automation

## Migration Guide

### From v1.x to v2.0.0

**No Breaking Changes**: All existing single-region deployments continue to work as before.

**New Features Available**:
- Use new "Deploy Multi-Region VPN Network" workflow for global deployments
- Enhanced region selection in single-region workflows
- Improved documentation and cost management guidance

### Upgrading Existing Deployments

Existing single-region deployments are fully compatible with v2.0.0. No action required.

To add multi-region capabilities:
1. Use the new multi-region workflow for new deployments
2. Existing single-region deployments can be maintained independently
3. Each region deployment is independent and isolated

## Contributors

- **cflarios** - Project creator and maintainer
- Built with assistance from GitHub Copilot

## Support

- **Issues**: [GitHub Issues](https://github.com/cflarios/terraform-aws-vpn/issues)
- **Discussions**: [GitHub Discussions](https://github.com/cflarios/terraform-aws-vpn/discussions)
- **Documentation**: See README files in each component directory

---

*For detailed technical documentation, see the README files in the project directories.*
