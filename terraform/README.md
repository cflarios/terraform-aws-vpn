# Terraform AWS VPN Infrastructure

Este proyecto de Terraform crea una infraestructura básica en AWS para un servidor VPN con los siguientes componentes:

## Recursos creados

- **VPC** pequeña en `us-east-1`
- **Subnet pública** con Internet Gateway
- **Security Group** con puertos habilitados:
  - 22 (SSH)
  - 80 (HTTP)
  - 443 (HTTPS)
  - 51820 (WireGuard VPN)
- **Instancia EC2** con Ubuntu 22.04 LTS

## Estructura del proyecto

```
terraform/
├── main.tf                     # Configuración principal
├── variables.tf                # Variables de entrada
├── outputs.tf                  # Valores de salida
├── terraform.tfvars.example    # Ejemplo de configuración
└── modules/
    ├── vpc/                    # Módulo de red
    ├── security_group/         # Módulo de seguridad
    └── ec2/                    # Módulo de instancia
```

## Requisitos previos

1. **AWS CLI** configurado con credenciales válidas
2. **Terraform** instalado (versión >= 1.0)
3. **SSH key** generada en `~/.ssh/vpn-server-key` (se crea automáticamente si no existe)

## Uso

### 1. Generar SSH Key (si no existe)

```bash
# El proyecto espera que exista una clave SSH en ~/.ssh/vpn-server-key
# Si no existe, puedes generarla con:
ssh-keygen -t rsa -b 4096 -f ~/.ssh/vpn-server-key -N "" -C "vpn-server-key"
```

### 2. Configurar variables

```bash
# Copiar el archivo de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Editar las variables según tus necesidades
```

### 3. Inicializar Terraform

```bash
terraform init
```

### 4. Planificar el despliegue

```bash
terraform plan
```

### 5. Aplicar la configuración

```bash
terraform apply
```

### 6. Ver outputs

```bash
terraform output
```

## Outputs importantes

- **instance_public_ip**: Dirección IP pública de la instancia
- **ssh_connection_command**: Comando completo para conectarse via SSH
- **key_pair_name**: Nombre del key pair creado en AWS
- **instance_public_dns**: DNS público de la instancia

## Verificar el despliegue

Una vez aplicada la configuración, puedes verificar que todo funciona:

```bash
# Ver la IP pública
terraform output instance_public_ip

# Ver el comando completo de SSH
terraform output ssh_connection_command

# Conectarse via SSH usando la clave generada
ssh -i ~/.ssh/vpn-server-key ubuntu@$(terraform output -raw instance_public_ip)
```

## Limpiar recursos

Para eliminar todos los recursos creados:

```bash
terraform destroy
```

## Personalización

Puedes modificar las variables en `terraform.tfvars` para:

- Cambiar el tipo de instancia
- Modificar los rangos de IP
- Usar diferentes zonas de disponibilidad
- Cambiar el nombre del entorno

**Nota**: La SSH key se lee automáticamente desde `~/.ssh/vpn-server-key.pub`

## Seguridad

⚠️ **Importante**: Este setup abre los puertos a todo Internet (0.0.0.0/0). Para producción, considera:

- Restringir el acceso SSH a IPs específicas
- Usar un bastion host
- Implementar autenticación adicional
- Configurar monitoring y logging
