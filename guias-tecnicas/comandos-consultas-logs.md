# Comandos de Consulta y Logs - Cluster RasPi

## 📚 Glosario de Parámetros

### SSH
- `-o IdentitiesOnly=yes`: Usar solo la clave especificada, evitar múltiples intentos de autenticación
- `-i ~/.ssh/raspi.pem`: Especificar archivo de clave privada
- `-L puerto_local:destino:puerto_destino`: Crear túnel SSH (port forwarding)
- `-N`: No ejecutar comando remoto, solo mantener conexión
- `-p puerto`: Puerto SSH (no estándar: 5022 master, 6022 worker)

### kubectl
- `-n namespace`: Especificar namespace
- `-o wide`: Mostrar información extendida (IPs, nodos)
- `--tail=N`: Mostrar últimas N líneas de logs
- `-w`: Watch mode, actualizar continuamente
- `-f archivo.yaml`: Aplicar manifiesto desde archivo
- `get`: Obtener recursos
- `logs`: Ver logs de pods
- `describe`: Información detallada de recursos
- `exec`: Ejecutar comando en contenedor

### Comandos de Sistema
- `ps aux`: Procesos del sistema
- `df -h`: Espacio en disco
- `free -h`: Memoria disponible
- `curl -I`: Solo headers HTTP
- `curl -s -o /dev/null -w "%{http_code}"`: Solo código de respuesta HTTP

---

## 🔧 Comandos por Servicio

### Kubernetes - Acceso y Gestión

#### Verificar Estado del Cluster
```bash
# Estado general de pods en todos los namespaces
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -A"

# Estado de pods en namespace específico
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -n vaultwarden"

# Información detallada de pods con IPs y nodos
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -n vaultwarden -o wide"
```
**Propósito**: Verificar que todos los servicios estén funcionando correctamente
**Información obtenida**: Estado de pods, IPs, nodos asignados, tiempo de ejecución

#### Aplicar Manifiestos Kubernetes
```bash
# Aplicar manifiesto desde archivo local
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl apply -f -" < archivo.yaml

# Aplicar manifiesto específico
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl apply -f vaultwarden-deployment.yaml"
```
**Propósito**: Desplegar o actualizar servicios en el cluster
**Información obtenida**: Confirmación de recursos creados/modificados

#### Monitoreo Continuo
```bash
# Watch pods en tiempo real
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -n vaultwarden -w"
```
**Propósito**: Observar cambios en tiempo real durante despliegues o troubleshooting
**Información obtenida**: Cambios de estado, reinicios, errores

### Vaultwarden - Logs y Estado

#### Ver Logs del Servicio
```bash
# Logs del deployment Vaultwarden
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl logs -n vaultwarden deployment/vaultwarden"

# Últimas 20 líneas de logs
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl logs -n vaultwarden deployment/vaultwarden --tail=20"

# Logs de pod específico
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl logs -n vaultwarden pod/vaultwarden-XXXXX"
```
**Propósito**: Diagnosticar problemas, verificar funcionamiento, monitorear actividad
**Información obtenida**: Errores, advertencias, eventos de inicio, actividad de usuarios

#### Verificar Servicios
```bash
# Listar servicios en namespace Vaultwarden
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get svc -n vaultwarden"

# Información detallada de servicios
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl describe svc vaultwarden -n vaultwarden"
```
**Propósito**: Verificar conectividad y configuración de servicios
**Información obtenida**: IPs de servicios, puertos, selectores, endpoints

#### Verificar Almacenamiento
```bash
# Estado de PersistentVolumes y PersistentVolumeClaims
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pv,pvc -n vaultwarden"

# Información detallada de almacenamiento
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl describe pvc vaultwarden-data -n vaultwarden"
```
**Propósito**: Verificar que el almacenamiento persistente esté funcionando
**Información obtenida**: Estado de volúmenes, capacidad, nodos asignados

### Prometheus/Grafana - Monitoreo

#### Verificar Stack de Monitoreo
```bash
# Estado de pods de Prometheus/Grafana
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -n kube-prometheus-stack"

# Logs de Prometheus
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl logs -n kube-prometheus-stack deployment/kube-prometheus-stack-prometheus"
```
**Propósito**: Verificar que el sistema de monitoreo esté funcionando
**Información obtenida**: Estado de métricas, alertas, configuración

### SSH y Acceso Remoto

#### Acceso Directo al Cluster
```bash
# Acceso al master node
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022

# Acceso al worker node
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 6022
```
**Propósito**: Acceso directo para troubleshooting avanzado
**Información obtenida**: Acceso completo al sistema

#### Túnel SSH para Acceso Web
```bash
# Túnel para acceder a Vaultwarden
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem -L 8080:localhost:30080 carlos@k8sraspi.myddns.me -p 6022 -N

# Túnel para kubectl (no usado actualmente)
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem -L 6443:localhost:6443 carlos@k8sraspi.myddns.me -p 5022 -N
```
**Propósito**: Acceso web seguro a servicios internos del cluster
**Información obtenida**: Acceso a interfaces web de servicios

### Diagnóstico de Problemas

#### Verificar Procesos SSH
```bash
# Ver procesos SSH activos
ps aux | grep -E "(ssh|port-forward)" | grep -v grep

# Matar procesos SSH específicos
kill PID
pkill -f "ssh.*8080"
```
**Propósito**: Gestionar conexiones SSH y túneles
**Información obtenida**: Procesos SSH activos, PIDs

#### Verificar Conectividad
```bash
# Test de conectividad HTTP
curl -I http://localhost:8080

# Test de conectividad desde worker node
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 6022 "curl -I http://10.244.1.190"
```
**Propósito**: Verificar que los servicios respondan correctamente
**Información obtenida**: Códigos de respuesta HTTP, headers de seguridad

---

## 📁 Scripts y Archivos Útiles

### Scripts de Acceso
- `access-vaultwarden.sh`: Script automatizado para acceder a Vaultwarden
- `kubectl-raspi-proxy.sh`: Script para configuración de kubectl (no usado actualmente)

### Archivos de Configuración
- `vaultwarden-*.yaml`: Manifiestos Kubernetes de Vaultwarden
- `config`: Configuración kubectl del cluster (archivo sensible)
- `*.ovpn`: Configuraciones OpenVPN (archivos sensibles)

### Archivos de Documentación
- `vaultwarden-credentials.md`: Credenciales y acceso (archivo sensible)
- `doc/diario-trabajo.md`: Historial completo de trabajo
- `doc/estado-proyecto.md`: Estado actual del proyecto

---

## 🔐 Comandos de Administrador

**Solo para administradores del cluster**:
- Comandos de aplicación de manifiestos (`kubectl apply`)
- Comandos de modificación de deployments (`kubectl patch`)
- Acceso SSH directo a nodos
- Gestión de túneles SSH

**Para usuarios finales**:
- Consulta de logs y estado
- Acceso web a servicios
- Verificación de conectividad

---

## 📝 Notas de Uso

1. **Siempre verificar información sensible** antes de usar comandos que muestren logs o configuración
2. **Usar placeholders** para credenciales en documentación pública
3. **Mantener túneles SSH activos** para acceso web a servicios
4. **Monitorear logs regularmente** para detectar problemas temprano
5. **Documentar cambios** en el diario de trabajo

---

**Última actualización**: 2025-08-24  
**Estado**: ✅ Comandos verificados y funcionando
