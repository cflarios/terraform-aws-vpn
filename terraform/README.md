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
3. **Key pair** en AWS (opcional, para acceso SSH)

## Uso

### 1. Configurar variables

```bash
# Copiar el archivo de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Editar las variables según tus necesidades
# Especialmente si quieres usar un key pair para SSH
```

### 2. Inicializar Terraform

```bash
terraform init
```

### 3. Planificar el despliegue

```bash
terraform plan
```

### 4. Aplicar la configuración

```bash
terraform apply
```

### 5. Ver outputs

```bash
terraform output
```

## Outputs importantes

- **instance_public_ip**: Dirección IP pública de la instancia
- **ssh_connection_command**: Comando para conectarse via SSH
- **instance_public_dns**: DNS público de la instancia

## Verificar el despliegue

Una vez aplicada la configuración, puedes verificar que todo funciona:

```bash
# Ver la IP pública
terraform output instance_public_ip

# Conectarse via SSH (si configuraste un key pair)
ssh -i tu-key-pair.pem ubuntu@$(terraform output -raw instance_public_ip)
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
- Configurar un key pair para SSH

## Seguridad

⚠️ **Importante**: Este setup abre los puertos a todo Internet (0.0.0.0/0). Para producción, considera:

- Restringir el acceso SSH a IPs específicas
- Usar un bastion host
- Implementar autenticación adicional
- Configurar monitoring y logging
