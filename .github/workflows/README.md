# 🚀 GitHub Actions Workflows para VPN

Este directorio contiene workflows de GitHub Actions para gestión automatizada de la infraestructura VPN temporal.

## 📋 Workflows Disponibles

### 1. 🚀 Deploy VPN Infrastructure (`cicd_creation.yml`)
**Propósito**: Despliega completamente la infraestructura VPN de forma temporal

**Trigger**: Manual (workflow_dispatch)

**Parámetros configurables**:
- **Environment**: Nombre del entorno (dev, staging, prod)
- **Instance Type**: Tipo de instancia EC2 (t3.micro, t3.small, t3.medium)
- **WireGuard Peers**: Número de clientes VPN a generar (1-10)

**Proceso**:
1. 🏗️ **Terraform**: Crea infraestructura AWS (VPC, EC2, Security Groups)
2. 🔑 **SSH Key**: Genera claves automáticamente
3. ⏳ **Espera**: Aguarda a que la instancia esté lista
4. 🐳 **Ansible**: Configura Docker + WireGuard
5. 📱 **Configuraciones**: Genera clientes VPN automáticamente
6. 🌐 **Servidor Web**: Activa servidor para descargar configs (puerto 8080)

**Outputs**:
- IP pública de la instancia
- URL del servidor web de configuraciones
- Instrucciones de acceso SSH

### 2. 🗑️ Destroy VPN Infrastructure (`cicd_destroy.yml`)
**Propósito**: Destruye completamente la infraestructura para ahorrar costos

**Trigger**: Manual (workflow_dispatch)

**Parámetros**:
- **Confirmation**: Debes escribir "DESTROY" para confirmar
- **Environment**: Nombre del entorno a destruir

**Proceso**:
1. ✋ **Validación**: Confirma que realmente quieres destruir
2. 🗑️ **Terraform Destroy**: Elimina todos los recursos AWS
3. 🧹 **Cleanup**: Limpia artefactos y datos temporales

## 🔧 Configuración Inicial

### 1. Secrets de GitHub
Debes configurar estos secrets en tu repositorio GitHub:

```
Settings → Secrets and variables → Actions → New repository secret
```

**Secrets requeridos**:
- `AWS_ACCESS_KEY_ID`: Tu AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY`: Tu AWS Secret Access Key

### 2. Permisos AWS
Tu usuario AWS debe tener permisos para:
- EC2 (crear/eliminar instancias, security groups, key pairs)
- VPC (crear/eliminar VPCs, subnets, internet gateways)
- IAM (si usas roles específicos)

### 3. Permisos del Repositorio
Los workflows necesitan:
- `contents: read` - Para leer el código
- `actions: write` - Para gestionar artefactos
- `id-token: write` - Para AWS (si usas OIDC)

## 🚀 Cómo Usar

### Desplegar VPN (Uso Temporal)

1. **Ir a GitHub Actions**:
   ```
   Tu Repositorio → Actions → "Deploy VPN Infrastructure"
   ```

2. **Configurar parámetros**:
   - Environment: `dev` (o tu preferencia)
   - Instance Type: `t3.micro` (más barato)
   - WireGuard Peers: `3` (número de dispositivos)

3. **Ejecutar workflow**:
   - Click "Run workflow"
   - Espera ~5-10 minutos

4. **Obtener configuraciones**:
   - Al terminar, verás la IP pública en el summary
   - Ve a `http://TU_IP_PUBLICA:8080`
   - Descarga archivos `.conf` para desktop
   - Descarga archivos `.png` (QR) para móviles

### Conectar Dispositivos

#### Desktop (Windows/Mac/Linux)
1. Instala WireGuard cliente
2. Descarga archivo `.conf` desde el servidor web
3. Importa configuración
4. ¡Conecta!

#### Móvil (Android/iOS)
1. Instala WireGuard app
2. Descarga imagen QR desde el servidor web
3. Escanea QR desde la imagen guardada
4. ¡Conecta!

### Destruir VPN (Ahorrar Costos)

1. **Ir a GitHub Actions**:
   ```
   Tu Repositorio → Actions → "Destroy VPN Infrastructure"
   ```

2. **Confirmar destrucción**:
   - Confirmation: Escribe exactamente `DESTROY`
   - Environment: Debe coincidir con el desplegado

3. **Ejecutar workflow**:
   - Click "Run workflow"
   - Espera ~3-5 minutos

4. **Verificar**:
   - Todos los recursos AWS eliminados
   - Sin más costos

## 💰 Consideraciones de Costos

### Instancia EC2 t3.micro
- **Costo aprox**: $0.0104/hora (~$0.25/día)
- **Free Tier**: 750 horas gratis/mes para nuevas cuentas AWS

### Otros recursos
- VPC, Security Groups, Key Pairs: **GRATIS**
- Transferencia de datos: Mínima para VPN personal

### ⚠️ Importante
- **SIEMPRE destruye** la infraestructura cuando termines
- Usar solo cuando necesites VPN
- Monitorea costos en AWS Console

## 🔄 Flujo de Trabajo Típico

```bash
# Viernes por la noche - Necesito VPN para el fin de semana
1. GitHub → Actions → "Deploy VPN Infrastructure" → Run
2. Esperar 10 minutos
3. Ir a http://IP:8080 y descargar configuraciones
4. Conectar dispositivos
5. Usar VPN todo el fin de semana

# Lunes por la mañana - Ya no necesito VPN
1. GitHub → Actions → "Destroy VPN Infrastructure" 
2. Confirmation: "DESTROY" → Run
3. Esperar 5 minutos
4. ✅ Sin costos hasta la próxima vez
```

## 🛠️ Troubleshooting

### Workflow falla en Terraform
- Verificar que los secrets AWS estén configurados
- Revisar permisos del usuario AWS
- Verificar limits de EC2 en tu región

### No puedo conectarme a la VPN
- Verificar que descargaste la configuración correcta
- Comprobar que el Security Group tiene puerto 51820 abierto
- Verificar que el contenedor WireGuard esté corriendo

### El servidor web no responde
- Verificar que el puerto 8080 esté abierto en Security Group
- SSH a la instancia y verificar: `sudo docker logs wireguard`
- Reiniciar contenedor: `sudo docker-compose restart`

### Costos inesperados
- Verificar que destruiste la infraestructura anterior
- Revisar AWS Cost Explorer
- Configurar AWS Billing Alerts

## 📊 Monitoreo

### Logs de GitHub Actions
- Cada paso del workflow está logueado
- Outputs importantes se muestran en el summary
- Los errores muestran detalles específicos

### Logs de AWS
- CloudTrail: Auditoría de cambios
- EC2 Console: Estado de instancias
- VPC Console: Configuración de red

### Logs de WireGuard
```bash
# SSH a la instancia
ssh -i ~/.ssh/vpn-server-key ubuntu@TU_IP

# Ver logs del contenedor
sudo docker logs wireguard -f

# Ver clientes conectados
sudo docker exec wireguard wg show
```
