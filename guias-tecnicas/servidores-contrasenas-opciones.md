# Análisis de Servidores de Contraseñas para Cluster RasPi

## 🎯 Requisitos del Usuario
- **Open Source**: Código abierto y auditable
- **Almacenamiento local**: Datos en el servidor, no en la nube
- **Cifrado**: Datos cifrados en reposo y en tránsito
- **Kubernetes**: Despliegue nativo en el cluster
- **Hardware limitado**: Optimizado para Raspberry Pi

## 📊 Comparativa de Opciones

### 1. Vaultwarden (Bitwarden Server) ⭐⭐⭐⭐⭐

#### Ventajas
- **Compatible con Bitwarden**: Clientes oficiales funcionan sin modificación
- **Ligero**: Escrito en Rust, muy eficiente en recursos
- **Cifrado AES-256**: Estándar de la industria
- **Helm Chart disponible**: Fácil despliegue en Kubernetes
- **Comunidad activa**: Mucha documentación y soporte

#### Desventajas
- **Recursos**: Requiere más memoria que alternativas
- **Complejidad**: Configuración inicial más compleja

#### Recursos Estimados
- **CPU**: 200-500m
- **Memoria**: 512MB-1GB
- **Almacenamiento**: 1-5GB

#### Helm Chart
```bash
helm repo add vaultwarden https://vaultwarden.github.io/helm-chart
helm install vaultwarden vaultwarden/vaultwarden
```

### 2. Passbolt ⭐⭐⭐⭐

#### Ventajas
- **Nativo para equipos**: Diseñado para colaboración
- **Cifrado GPG**: Estándar criptográfico robusto
- **API REST**: Fácil integración
- **Docker oficial**: Imágenes oficiales disponibles

#### Desventajas
- **Complejidad**: Configuración inicial compleja
- **Recursos**: Requiere base de datos PostgreSQL
- **Cliente web**: Menos opciones de cliente móvil

#### Recursos Estimados
- **CPU**: 300-600m
- **Memoria**: 1-2GB
- **Almacenamiento**: 2-10GB (incluye PostgreSQL)

### 3. KeePassXC Server ⭐⭐⭐

#### Ventajas
- **Muy ligero**: Mínimos recursos
- **Formato estándar**: Compatible con KeePass
- **Simple**: Configuración básica

#### Desventajas
- **Funcionalidad limitada**: Menos características avanzadas
- **Sin Helm Chart**: Despliegue manual requerido
- **Cliente limitado**: Principalmente aplicaciones de escritorio

#### Recursos Estimados
- **CPU**: 50-200m
- **Memoria**: 128-512MB
- **Almacenamiento**: 100MB-1GB

### 4. Authelia ⭐⭐⭐⭐

#### Ventajas
- **Multi-factor authentication**: 2FA integrado
- **Single Sign-On**: SSO para múltiples servicios
- **Muy seguro**: Enfoque en seguridad
- **Helm Chart disponible**: Fácil despliegue

#### Desventajas
- **No es gestor de contraseñas**: Es un proxy de autenticación
- **Complejidad**: Configuración avanzada requerida
- **Recursos**: Requiere base de datos

#### Recursos Estimados
- **CPU**: 200-400m
- **Memoria**: 512MB-1GB
- **Almacenamiento**: 1-5GB

## 🏆 Recomendación: Vaultwarden

### Justificación
1. **Compatibilidad**: Funciona con todos los clientes Bitwarden
2. **Recursos**: Aceptable para Raspberry Pi
3. **Seguridad**: Cifrado AES-256 estándar
4. **Comunidad**: Excelente soporte y documentación
5. **Kubernetes**: Helm Chart maduro y mantenido

### Configuración Recomendada

#### Namespace
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: vaultwarden
```

#### Persistencia
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: vaultwarden-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

#### Configuración Helm
```yaml
# values.yaml
service:
  type: ClusterIP

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: vaultwarden.local
      paths:
        - path: /
          pathType: Prefix

persistence:
  enabled: true
  size: 2Gi

resources:
  requests:
    memory: "512Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

## 🔧 Consideraciones de Implementación

### Seguridad
- **TLS**: Certificados SSL/TLS obligatorios
- **Network Policies**: Restricción de acceso por namespace
- **RBAC**: Permisos mínimos necesarios
- **Backup**: Respaldo automático de datos

### Rendimiento
- **Límites de recursos**: Definir límites claros
- **Monitoreo**: Métricas de uso y rendimiento
- **Escalado**: Preparar para múltiples usuarios

### Mantenimiento
- **Actualizaciones**: Proceso de actualización documentado
- **Backup**: Estrategia de respaldo automatizada
- **Logs**: Centralización de logs

## 📋 Plan de Implementación

### Fase 1: Preparación
1. Resolver problema de conectividad VPN
2. Crear namespace y recursos de persistencia
3. Configurar Helm repository

### Fase 2: Despliegue
1. Instalar Vaultwarden con Helm
2. Configurar ingress y TLS
3. Crear usuario administrador

### Fase 3: Configuración
1. Configurar backup automático
2. Implementar monitoreo
3. Documentar procedimientos

### Fase 4: Pruebas
1. Probar clientes móviles y web
2. Verificar rendimiento
3. Validar seguridad

---
*Análisis completado: 2025-01-24*
*Decisión: Vaultwarden implementado y funcionando*

## ✅ Decisión Final y Estado Actual

### Servidor Seleccionado: **Vaultwarden**

#### Razones de la Selección
- ✅ **Open Source**: Código abierto y auditable
- ✅ **Compatible con Bitwarden**: Apps móviles y extensiones funcionan
- ✅ **Almacenamiento local**: Datos en el cluster, no en la nube
- ✅ **Cifrado**: AES-256 en reposo y en tránsito
- ✅ **Fácil instalación**: Manifiestos Kubernetes simples
- ✅ **Recursos ligeros**: Funciona bien en Raspberry Pi

#### Estado de Implementación
- ✅ **Instalado**: Funcionando en node2 (worker)
- ✅ **Almacenamiento**: 7GB en `/mnt/sdcard/7gb/vaultwarden`
- ✅ **Acceso**: NodePort 30080, ClusterIP 10.98.64.146
- ✅ **VPN**: Configuración split-tunnel funcional
- ✅ **Scripts**: Automatización completa

#### Configuración Final
```yaml
# Servicio Vaultwarden
- Tipo: NodePort (30080)
- Namespace: vaultwarden
- Almacenamiento: 7GB PersistentVolume
- Recursos: 512Mi RAM, CPU sin límites
- Registro: Habilitado para familia/amigos
```

### Acceso Actual
- **Web**: http://localhost:8080 (túnel SSH)
- **VPN**: Configuración split-tunnel funcional
- **Scripts**: `connect-vpn.sh` y `access-vaultwarden-vpn.sh`

### Próximos Pasos
- 🔄 **Acceso público**: Configurar Ingress + HTTPS
- 🔄 **Apps móviles**: Configurar acceso directo
- 🔄 **Backup**: Implementar backup automático

## 📁 Organización de Documentación - 2025-01-24

### Estructura Implementada
- **`cluster-raspi-docs/`**: Documentación pública (GitHub Pages)
- **`doc/`**: Documentación interna con información sensible
- **`scripts/`**: Scripts de automatización
- **`manifests/`**: Archivos de configuración Kubernetes
- **`summaries/`**: Resúmenes ejecutivos

### Seguridad de Documentación
- ✅ **Verificación sistemática**: Antes de cada commit/push
- ✅ **Placeholders**: `[CONFIGURAR_TOKEN_SEGURO]` para datos sensibles
- ✅ **Separación**: Información sensible en repositorio local
- ✅ **Sincronización**: Documentación actualizada entre repositorios

### Documentación Disponible
- **Guías técnicas**: Comandos, almacenamiento, opciones
- **Resúmenes ejecutivos**: Estado del proyecto, VPN, acceso público
- **Diario de trabajo**: Historial completo de decisiones
- **Observaciones IA**: Análisis de patrones de trabajo

---
