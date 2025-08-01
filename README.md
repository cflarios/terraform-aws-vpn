# terraform-aws-vpn

Infraestructura como código para desplegar un servidor VPN en AWS usando Terraform y configuración con Ansible.

## Estructura del proyecto

```
├── terraform/          # Infraestructura con Terraform
│   ├── modules/        # Módulos reutilizables
│   │   ├── vpc/       # Configuración de red
│   │   ├── security_group/  # Reglas de seguridad
│   │   └── ec2/       # Instancia del servidor
│   ├── main.tf        # Configuración principal
│   ├── variables.tf   # Variables de entrada
│   ├── outputs.tf     # Valores de salida
│   └── README.md      # Documentación de Terraform
└── ansible/           # Configuración del servidor
```

## Características

### Infraestructura (Terraform)
- VPC pequeña en `us-east-1`
- Instancia EC2 con Ubuntu 22.04 LTS
- Security Group con puertos:
  - 22 (SSH)
  - 80 (HTTP) 
  - 443 (HTTPS)
  - 51820 (WireGuard VPN)
- Output con IP pública del servidor

### Configuración (Ansible)
- Instalación automática de WireGuard
- Configuración del servidor VPN
- Generación de clientes y códigos QR
- Firewall configurado (UFW)
- NAT y enrutamiento automático

## Inicio rápido

1. **Desplegar infraestructura**:
   ```bash
   cd terraform/
   terraform init
   terraform plan
   terraform apply
   ```

2. **Obtener IP pública**:
   ```bash
   terraform output instance_public_ip
   ```

3. **Configurar servidor con Ansible**:
   ```bash
   cd ../ansible/
   
   # Deploy automático (recomendado)
   ./deploy.sh <IP_PUBLICA_DEL_SERVIDOR>
   
   # O manual:
   # Editar inventory.ini con la IP del servidor
   ansible-playbook site.yml
   ```

4. **Obtener configuraciones de cliente**:
   ```bash
   # Descargar configuración para desktop
   scp -i ~/.ssh/vpn-server-key ubuntu@<IP>:/etc/wireguard/clients/client1.conf .
   
   # Ver código QR para móvil
   ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo cat /etc/wireguard/clients/mobile1-qr.txt'
   ```

## Documentación

- [Documentación de Terraform](./terraform/README.md)
- [Documentación de Ansible](./ansible/README.md)

## Requisitos

- AWS CLI configurado
- Terraform >= 1.0
- Ansible
- Key pair de AWS (se crea automáticamente)