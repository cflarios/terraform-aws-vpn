# Ansible WireGuard Docker Configuration

Este directorio contiene playbooks de Ansible para configurar automáticamente un servidor WireGuard VPN usando Docker en tu instancia EC2.

## 📋 Características

- **Instalación automática** de Docker y docker-compose
- **Contenedor WireGuard** usando imagen linuxserver/wireguard
- **Configuración automática** del servidor con la IP pública
- **Generación automática** de clientes (peers) con QR codes
- **Servidor web integrado** para descarga fácil de configuraciones (puerto 8080)
- **Firewall configurado** (UFW) con reglas de seguridad
- **Sin configuración manual** de claves o archivos

## 🗂️ Estructura

```
ansible/
├── site.yml                    # Playbook principal
├── inventory.ini               # Inventario de servidores
├── ansible.cfg                 # Configuración de Ansible
├── deploy.sh                   # Script de deploy automatizado
├── group_vars/
│   └── all.yml                 # Variables globales
└── roles/
    └── wireguard-docker/
        ├── tasks/              # Tareas de instalación Docker + WireGuard
        ├── templates/          # Templates (docker-compose, scripts)
        └── handlers/           # Handlers para servicios
```

## 🚀 Uso rápido

### 1. Deploy automatizado

```bash
# Usar el script de deploy (recomendado)
./deploy.sh <IP_DEL_SERVIDOR>

# Ejemplo:
./deploy.sh 54.123.456.789
```

### 2. Acceder a configuraciones

```bash
# Servidor web para descargas (¡MUY FÁCIL!)
http://<IP_DEL_SERVIDOR>:8080

# Descargar configuración específica por SCP
scp -i ~/.ssh/vpn-server-key ubuntu@<IP>:/root/wireguard/peer1/peer1.conf .
```

## 📋 Requisitos previos

1. **Ansible instalado**:
   ```bash
   sudo apt update
   sudo apt install ansible
   ```

2. **Clave SSH configurada**:
   - Debe existir en `~/.ssh/vpn-server-key`
   - Si no existe: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/vpn-server-key`

3. **Instancia EC2 ejecutándose**:
   - Con Ubuntu 22.04 LTS
   - Puertos 22, 80, 443, 51820, 8080 abiertos
   - Acceso SSH configurado

## ⚙️ Configuración

### Variables principales (group_vars/all.yml)

```yaml
wireguard:
  internal_subnet: "10.13.13.0"    # Red interna de WireGuard
  server_port: 51820               # Puerto UDP de WireGuard
  peers: 3                         # Número de clientes a generar
  peer_dns: "auto"                 # DNS para clientes
  timezone: "America/Bogota"       # Zona horaria del contenedor

docker:
  compose_version: "2.24.0"        # Versión de docker-compose
```

### Agregar más clientes

1. Edita `group_vars/all.yml`
2. Cambia el número de peers:
   ```yaml
   peers: 5  # Genera 5 clientes en lugar de 3
   ```
3. Re-ejecuta el playbook: `ansible-playbook site.yml`

## 📱 Uso después del deploy

### 🌐 Servidor web para descargas (¡NUEVO!)
```bash
# Abrir en navegador
http://<IP_SERVIDOR>:8080

# Lista todas las configuraciones con descargas directas
# Incluye archivos .conf para desktop y .png (QR) para móvil
```

### Ver estado del contenedor Docker
```bash
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP_SERVIDOR> 'sudo docker ps'
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP_SERVIDOR> 'sudo docker logs wireguard'
```

### Descargar configuración específica por SCP
```bash
# Listar configuraciones disponibles
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP_SERVIDOR> 'sudo ls /root/wireguard/peer*/'

# Descargar configuración
scp -i ~/.ssh/vpn-server-key ubuntu@<IP_SERVIDOR>:/root/wireguard/peer1/peer1.conf .
```

### Ver script de ayuda
```bash
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP_SERVIDOR> 'sudo /root/download-configs.sh'
```

## 🔧 Configuración de clientes

### Desktop (Windows/Mac/Linux)
1. Instala WireGuard cliente
2. Ve a `http://<IP_SERVIDOR>:8080` y descarga el archivo `.conf`
3. Importa el archivo `.conf` en WireGuard
4. Conecta

### Móvil (Android/iOS)
1. Instala WireGuard app
2. Ve a `http://<IP_SERVIDOR>:8080` y descarga el archivo `.png` (QR code)
3. En la app, escanea el código QR desde la imagen descargada
4. Conecta

## 🔒 Seguridad

El playbook configura automáticamente:

- **Docker container** aislado para WireGuard
- **Firewall UFW** con reglas específicas
- **Claves únicas** generadas automáticamente por el contenedor
- **Servidor web temporal** en puerto 8080 (puedes cerrarlo después)
- **NAT automático** configurado por el contenedor

## 🛠️ Troubleshooting

### Error de conectividad SSH
```bash
# Verificar conectividad detallada
ansible vpn_servers -m ping -vvv
```

### Contenedor Docker no inicia
```bash
# Verificar logs del contenedor
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo docker logs wireguard'

# Reiniciar contenedor
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'cd /root/docker-wireguard && sudo docker-compose restart'
```

### No se pueden descargar configuraciones
```bash
# Verificar que el puerto 8080 esté abierto
# Verificar que el servidor HTTP esté corriendo
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo netstat -tlnp | grep 8080'

# Reiniciar servidor de configuraciones
ssh -i ~/.ssh/vpn-server-key ubuntu@<IP> 'sudo pkill -f serve-configs.py && cd /root/wireguard && nohup python3 /root/serve-configs.py > /var/log/config-server.log 2>&1 &'
```

### Cliente no se conecta
- Verificar que el puerto 51820 UDP esté abierto en AWS Security Group
- Verificar la configuración del cliente
- Verificar logs del contenedor: `sudo docker logs wireguard`

## 🔄 Comandos útiles

```bash
# Ver estado del contenedor
sudo docker ps

# Ver logs del contenedor
sudo docker logs wireguard -f

# Reiniciar WireGuard
cd /root/docker-wireguard && sudo docker-compose restart

# Ver configuraciones generadas
sudo ls -la /root/wireguard/peer*/

# Verificar firewall
sudo ufw status

# Acceder al contenedor (si necesitas debug)
sudo docker exec -it wireguard bash
```

## 🌟 Ventajas del setup con Docker

- ✅ **Instalación más rápida** y confiable
- ✅ **Sin configuración manual** de claves o archivos
- ✅ **Aislamiento** del sistema host
- ✅ **Actualizaciones fáciles** del contenedor
- ✅ **Servidor web integrado** para descargas
- ✅ **Configuración automática** de todo el stack
- ✅ **Portabilidad** entre diferentes sistemas
