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
  - 8080 (Servidor de configuraciones WireGuard) 
  - 51820 (WireGuard VPN)
- Output con IP pública del servidor

### Configuración (Ansible)
- Instalación automática de Docker y docker-compose
- Contenedor WireGuard usando imagen linuxserver/wireguard
- Generación automática de clientes (peers) con códigos QR
- Servidor web integrado para descarga de configuraciones (puerto 8080)
- Firewall configurado (UFW)

## Inicio rápido

### 🤖 Opción 1: Automatizado con GitHub Actions (Recomendado)

**Para uso temporal de VPN:**

1. **Configurar secrets en GitHub**:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. **Desplegar VPN**:
   ```
   GitHub → Actions → "Deploy VPN Infrastructure" → Run workflow
   ```

3. **Obtener configuraciones**:
   ```
   Ir a http://IP_PUBLICA:8080 (se muestra en el workflow)
   Descargar archivos .conf o QR codes
   ```

4. **Destruir cuando termines**:
   ```
   GitHub → Actions → "Destroy VPN Infrastructure" → Type "DESTROY" → Run
   ```

### 🛠️ Opción 2: Manual (Para desarrollo)

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
   # ¡Método más fácil! - Servidor web
   # Abrir en navegador: http://<IP_PUBLICA>:8080
   
   # O por SCP (método tradicional):
   scp -i ~/.ssh/vpn-server-key ubuntu@<IP>:/root/wireguard/peer1/peer1.conf .
   
   # Ver estado y troubleshooting
   ./troubleshoot.sh <IP_PUBLICA>
   ```

## Documentación

- [📖 Documentación de Terraform](./terraform/README.md)
- [🐳 Documentación de Ansible](./ansible/README.md)
- [🚀 Documentación de GitHub Actions](./.github/workflows/README.md)

## Casos de Uso

### 🎯 VPN Temporal (GitHub Actions)
- **Ideal para**: Uso ocasional, viajes, trabajo remoto temporal
- **Beneficios**: Sin costos cuando no usas, deploy en 10 minutos
- **Workflow**: Deploy → Usar → Destroy

### 🛠️ VPN Permanente (Manual)
- **Ideal para**: Desarrollo, testing, uso continuo
- **Beneficios**: Control total, personalización
- **Workflow**: Deploy una vez → Mantener corriendo

## Requisitos

### Para GitHub Actions
- Cuenta AWS con permisos EC2/VPC
- Secrets configurados en GitHub
- ✅ **No necesitas instalar nada localmente**

### Para deploy manual
- AWS CLI configurado
- Terraform >= 1.0
- Ansible (se instala automáticamente)
- Key pair de AWS (se crea automáticamente)