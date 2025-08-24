# Estado del Almacenamiento - Cluster RasPi

## 📊 Análisis de Espacio Disponible

### 🖥️ **Master Node (node1) - 192.168.1.49**
- **Disco principal**: 119.5GB (sda)
  - **Partición 1**: 512MB (/boot/firmware) - 64MB usado
  - **Partición 2**: 119GB (/) - 14GB usado, **98GB disponible**
- **Estado**: Sin particiones específicas para servicios

### 🖥️ **Worker Node (node2) - 192.168.1.52**
- **Disco principal**: 59GB (sda)
  - **Partición 1**: 510MB (/boot/firmware) - 56MB usado
  - **Partición 2**: 59GB (/) - 8.2GB usado, **48GB disponible**

- **MicroSD particionada** (mmcblk0):
  - **Partición 1**: 15GB (/mnt/sdcard/15gb) - 150MB usado, **14GB disponible**
  - **Partición 2**: 6.8GB (/mnt/sdcard/7gb) - 24KB usado, **6.5GB disponible**
  - **Partición 3**: 7.7GB (/mnt/sdcard/8gb) - 40MB usado, **7.3GB disponible**

### 📦 **Volúmenes Persistentes Activos**

#### Prometheus
- **PV**: prometheus-sdcard-pv
- **Capacidad**: 15GB
- **Estado**: Bound
- **Claim**: monitoring/prometheus-kube-prometheus-stack-prometheus-db-prometheus-kube-prometheus-stack-prometheus-0

#### Grafana
- **PV**: grafana-sdcard-pv
- **Capacidad**: 8GB
- **Estado**: Bound
- **Claim**: monitoring/storage-kube-prometheus-stack-grafana-0

## 🎯 **Espacio Disponible para Vaultwarden**

### Opciones de Almacenamiento

#### 1. **Partición Libre en MicroSD** ⭐⭐⭐⭐⭐
- **Ubicación**: /mnt/sdcard/7gb
- **Espacio**: 6.5GB disponible
- **Ventajas**: 
  - Espacio dedicado
  - Separado del sistema operativo
  - Fácil backup
- **Recomendación**: **USAR ESTA OPCIÓN**

#### 2. **Disco Principal del Worker** ⭐⭐⭐
- **Ubicación**: / (node2)
- **Espacio**: 48GB disponible
- **Ventajas**: Más espacio
- **Desventajas**: Mezclado con sistema operativo

#### 3. **Disco Principal del Master** ⭐⭐
- **Ubicación**: / (node1)
- **Espacio**: 98GB disponible
- **Ventajas**: Máximo espacio
- **Desventajas**: No recomendado para datos de aplicación

## 📋 **Plan de Implementación para Vaultwarden**

### Configuración Recomendada
```yaml
persistence:
  enabled: true
  size: 2Gi  # Suficiente para datos de contraseñas
  storageClass: ""  # Usar PV estático
  volumeName: vaultwarden-sdcard-pv
  accessModes:
    - ReadWriteOnce
```

### Creación del PersistentVolume
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: vaultwarden-sdcard-pv
  labels:
    app: vaultwarden
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  hostPath:
    path: /mnt/sdcard/7gb/vaultwarden
```

### Recursos Estimados para Vaultwarden
- **Almacenamiento**: 2GB (suficiente para miles de contraseñas)
- **CPU**: 200-500m
- **Memoria**: 512MB-1GB

## 🔧 **Consideraciones Técnicas**

### Backup
- **Ubicación**: /mnt/sdcard/7gb/vaultwarden
- **Frecuencia**: Diario
- **Retención**: 7 días
- **Método**: Script automatizado

### Monitoreo
- **Espacio usado**: Alertas al 80%
- **Rendimiento**: Métricas de I/O
- **Disponibilidad**: Health checks

### Seguridad
- **Permisos**: 700 (solo usuario del pod)
- **Cifrado**: AES-256 en reposo
- **Backup**: Cifrado con GPG

## 📈 **Métricas de Uso Actual**

### Prometheus
- **Asignado**: 15GB
- **Usado**: ~150MB (1%)
- **Disponible**: 14.85GB

### Grafana
- **Asignado**: 8GB
- **Usado**: ~40MB (0.5%)
- **Disponible**: 7.96GB

### Vaultwarden ⭐ **EN PRODUCCIÓN**
- **Asignado**: 7GB (partición completa)
- **Usado**: ~7GB (100%)
- **Estado**: ✅ Funcionando en producción
- **Ubicación**: /mnt/sdcard/7gb/vaultwarden
- **PersistentVolume**: vaultwarden-sdcard-pv (Bound)

### Espacio Libre Total
- **MicroSD**: 0GB (todas las particiones asignadas)
- **Worker**: 48GB (reserva para expansión)
- **Master**: 98GB (reserva para sistema)

## 🎯 **Estado Actual - 2025-01-24**

### ✅ **Vaultwarden Implementado**
- **Almacenamiento**: 7GB asignado y en uso
- **Estado**: Completamente operativo
- **Acceso**: http://localhost:8080 (via SSH tunnel)
- **Backup**: Configuración pendiente
- **Monitoreo**: Integrado con Prometheus/Grafana

### 📊 **Uso de Recursos**
- **CPU**: Bajo uso (Vaultwarden + monitoring)
- **Memoria**: Uso moderado
- **Almacenamiento**: 7GB de 7GB usados en node2

### 🔄 **Próximos Pasos**
1. **Configurar backup automático** de Vaultwarden
2. **Implementar monitoreo específico** para métricas de Vaultwarden
3. **Considerar expansión** si se necesita más espacio

## 🎯 **Recomendación Final**

**Usar la partición /mnt/sdcard/7gb** para Vaultwarden porque:
1. ✅ Espacio dedicado y separado
2. ✅ Fácil gestión de backups
3. ✅ No interfiere con otros servicios
4. ✅ Suficiente espacio para crecimiento
5. ✅ Consistente con la arquitectura actual
