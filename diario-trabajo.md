# Diario de Trabajo - Cluster RasPi

## 2025-08-24 - Renovación de Seguridad y Finalización del Proyecto

### 🔒 Renovación de Seguridad Realizada

**Problema identificado**: ADMIN_TOKEN de Vaultwarden expuesto en repositorios públicos.

**Acciones tomadas**:
1. **ADMIN_TOKEN renovado**: Token anterior comprometido, nuevo token generado y aplicado
2. **Documentación limpiada**: Información sensible eliminada de repositorios públicos
3. **Archivos sensibles protegidos**: Agregados a .gitignore
4. **Certificados Kubernetes**: Mantenidos para no interrumpir acceso de Carlos

**Estado de seguridad**:
- ✅ ADMIN_TOKEN renovado y aplicado
- ✅ Documentación pública limpia
- ✅ Repositorios organizados y seguros
- ✅ Acceso de Carlos mantenido

### 📁 Repositorios Finalizados

1. **cluster-raspi-docs** (GitHub): Documentación completa del proyecto
2. **raspk8s** (Pull Request): Manifiestos Kubernetes de Vaultwarden

### 📧 Comunicación con Carlos

Preparado correo con información sensible para transferencia segura del proyecto.

## 2025-08-24 - Finalización: Vaultwarden Completamente Funcional ✅

### Estado Final del Proyecto

**Vaultwarden completamente operativo**:
- ✅ Pod corriendo en node2 (worker node)
- ✅ Almacenamiento persistente de 2GB configurado
- ✅ Servicios ClusterIP y NodePort funcionando
- ✅ Acceso web disponible en http://localhost:8080
- ✅ Registro de usuarios habilitado para familia/amigos
- ✅ ADMIN_TOKEN configurado para gestión
- ✅ Script de acceso automatizado creado

**Archivos de Infraestructura Creados**:
- `vaultwarden-namespace.yaml` - Namespace dedicado
- `vaultwarden-pv.yaml` - PersistentVolume en /mnt/sdcard/7gb
- `vaultwarden-pvc.yaml` - PersistentVolumeClaim
- `vaultwarden-deployment.yaml` - Deployment con configuración completa
- `vaultwarden-service.yaml` - Servicio ClusterIP
- `vaultwarden-nodeport.yaml` - Servicio NodePort para acceso externo
- `access-vaultwarden.sh` - Script de acceso automatizado

**Documentación Generada**:
- `vaultwarden-credentials.md` - Credenciales y configuración
- `doc/guias-tecnicas/servidores-contrasenas-opciones.md` - Análisis de opciones
- `doc/guias-tecnicas/estado-almacenamiento.md` - Análisis de almacenamiento
- Actualización completa del diario de trabajo

### Próximos Pasos Planificados
1. **Organización de Repositorios**:
   - Actualizar repositorio `raspk8s` con archivos de infraestructura
   - Crear nuevo repositorio para documentación y scripts
   - Subir ambos a GitHub

2. **Compartir con Compañero**:
   - Documentación completa del proyecto
   - Instrucciones de acceso y gestión
   - Estado actual del cluster

3. **Mejoras Futuras**:
   - Configurar acceso web seguro (HTTPS + Ingress)
   - Configurar VPN para acceso remoto
   - Configurar backup automático
   - Integrar con monitoring existente

### Lecciones Aprendidas
- **Arquitectura**: Es mejor instalar servicios en worker nodes, no en master
- **Almacenamiento**: Usar particiones dedicadas para servicios críticos
- **Acceso**: NodePort + SSH tunnel es una solución práctica y segura
- **Documentación**: Mantener documentación actualizada es crucial para la continuidad

## 2024-12-25 - Sesión Inicial: Configuración del Entorno y Análisis del Proyecto

### 🎯 Objetivo de la Sesión
Instalación de un servidor de contraseñas open source en el cluster de Kubernetes de Raspberry Pi.

### 📋 Actividades Realizadas

#### 1. Análisis del Proyecto Existente ✅
- **Análisis de la estructura del proyecto**: Se identificó un cluster Kubernetes funcional con:
  - Master node en IP 192.168.1.49
  - Worker node (node2) con usuario carlos (UID 1000)
  - Stack de monitoreo completo (Prometheus + Grafana)
  - Almacenamiento persistente en MicroSD particionada
  - VPN OpenVPN configurada para acceso remoto

#### 2. Limpieza de Configuración kubectl ⚠️
- **Problema identificado**: El usuario estaba conectado a un cluster EKS de AWS en lugar del cluster local
- **Acciones tomadas**:
  ```bash
  kubectl config delete-context arn:aws:eks:eu-central-1:630638148792:cluster/digien-cluster-k8s
  kubectl config delete-cluster arn:aws:eks:eu-central-1:630638148792:cluster/digien-cluster-k8s
  kubectl config unset users.arn:aws:eks:eu-central-1:630638148792:cluster/digien-cluster-k8s
  ```
- **Configuración del cluster local**:
  ```bash
  KUBECONFIG=./config:~/.kube/config kubectl config view --flatten > ~/.kube/config
  kubectl config use-context raspberry
  ```

#### 3. Configuración de VPN - Problema Identificado ⚠️
- **Problema**: La configuración VPN original redirige todo el tráfico, cortando el acceso a internet
- **Primer intento**: 
  ```bash
  sudo openvpn --config raspi-udp.ovpn --daemon
  ```
  **Resultado**: Pérdida de conectividad a internet, proceso terminado manualmente

- **Segundo intento**: Creación de configuración split-tunnel
  ```bash
  # Creación de raspi-udp-split.ovpn con:
  route-nopull
  route 192.168.1.0 255.255.255.0
  route 10.244.0.0 255.255.0.0
  ```
  **Resultado**: VPN conecta pero no hay acceso al cluster (ping falla)

- **Estado actual**: VPN no funcional, necesaria revisión de configuración

#### 4. Sistema de Documentación Establecido ✅
- **Repositorio Git**: Inicializado en carpeta `doc/`
- **Estructura creada**:
  - README.md con convenciones
  - diario-trabajo.md (este archivo)
  - observaciones-ia.md
  - estado-proyecto.md
  - guias-tecnicas/ (carpeta)

#### 5. Resolución de Conectividad - SSH Directo ✅
- **Descubrimiento**: Configuración SSH en puertos no estándar
  - **Nodo1 (master)**: Puerto 5022
  - **Nodo2 (worker)**: Puerto 6022
- **Conexión exitosa**:
  ```bash
  ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022
  ```
- **Verificación del cluster**:
  ```bash
  kubectl get nodes
  NAME    STATUS   ROLES           AGE    VERSION
  node1   Ready    control-plane   431d   v1.32.6
  node2   Ready    <none>          100d   v1.32.6
  ```
- **Estado**: Cluster accesible vía SSH, VPN no necesaria para acceso básico

#### 6. Análisis de Almacenamiento y Recursos ✅
- **Master Node**: 98GB disponible en disco principal
- **Worker Node**: 48GB disponible + MicroSD particionada
  - **Partición 1**: 15GB (Prometheus) - 150MB usado
  - **Partición 2**: 6.8GB (libre) - 24KB usado
  - **Partición 3**: 7.7GB (Grafana) - 40MB usado
- **Recomendación**: Usar partición libre (/mnt/sdcard/7gb) para nuevos servicios

#### 7. Instalación de Helm Local ✅
- **Decisión**: Instalar Helm en máquina local en lugar del cluster
- **Razón**: Mantener cluster limpio y separar responsabilidades
- **Instalación**:
  ```bash
  curl https://get.helm.sh/helm-v3.14.3-linux-amd64.tar.gz -o helm.tar.gz
  tar -xzf helm.tar.gz && sudo mv linux-amd64/helm /usr/local/bin/
  ```

#### 8. Instalación de Vaultwarden ✅
- **Decisión**: Instalar en Worker Node (node2) por seguridad y arquitectura
- **Configuración**:
  - **Namespace**: vaultwarden
  - **Almacenamiento**: 2GB en /mnt/sdcard/7gb/vaultwarden
  - **Recursos**: 512MB-1GB RAM, 200-500m CPU
  - **Node Selector**: node2 (worker node)

- **Manifiestos creados**:
  - vaultwarden-namespace.yaml
  - vaultwarden-pv.yaml
  - vaultwarden-pvc.yaml
  - vaultwarden-deployment.yaml
  - vaultwarden-service.yaml

- **Instalación exitosa**:
  ```bash
  kubectl apply -f vaultwarden-*.yaml
  ```
- **Estado final**:
  - Pod: Running en node2 (10.244.1.190)
  - PV: Bound (2GB)
  - Service: ClusterIP creado
  - Port-forward: 8080:80 configurado

### 🔍 Observaciones Técnicas

#### Arquitectura del Cluster
- **Red de pods**: 10.244.0.0/16 (Flannel)
- **Container Runtime**: containerd (migrado desde Docker)
- **Almacenamiento**: MicroSD con particiones específicas para servicios
- **Monitoreo**: Stack completo con dashboards de Grafana expuestos vía ngrok

#### Problemas Identificados
- **VPN**: Configuración no funcional para acceso al cluster
- **Red**: Posible problema de routing o configuración de red
- **Conectividad**: Cluster no accesible desde red externa

#### Soluciones Implementadas
- **SSH Directo**: Acceso funcional vía puertos 5022/6022
- **Dominio dinámico**: k8sraspi.myddns.me resuelve a 88.7.208.182
- **Claves específicas**: raspi.pem para carlos, raspijavi para javier
- **Helm local**: Instalación en máquina local para mantener cluster limpio

#### Patrones de Trabajo del Usuario
- **Experiencia**: 25 años en sistemas e infraestructura cloud
- **Enfoque**: Metódico, prefiere documentación completa
- **Gestión de configuraciones**: Mantiene múltiples contextos kubectl organizados
- **Seguridad**: Utiliza VPN para acceso remoto, configuración de certificados
- **Resolución de problemas**: Identifica rápidamente problemas de conectividad
- **Documentación**: Mantiene información técnica detallada en múltiples fuentes
- **Arquitectura**: Prefiere separación de responsabilidades y cluster limpio

### 📝 Próximos Pasos
1. **Configurar acceso seguro**: Generar ADMIN_TOKEN seguro para Vaultwarden
2. **Configurar ingress**: Para acceso web permanente
3. **Configurar backup**: Sistema de respaldo automático
4. **Configurar monitoreo**: Alertas y métricas para Vaultwarden
5. **Documentar uso**: Guías de usuario y administración

### 🏷️ Tags
#configuracion #kubectl #vpn #analisis-proyecto #limpieza-entorno #problema-conectividad #split-tunnel #ssh-directo #resolucion-conectividad #helm-local #vaultwarden #instalacion-exitosa #worker-node #almacenamiento-dedicado

## 2025-01-24 - Trabajo en VPN del Cluster RasPi

### 🔍 Análisis del Problema VPN
- **Estado inicial**: VPN no funcional según documentación anterior
- **Nueva información**: Carlos confirma que la VPN funciona perfectamente en su sistema
- **Hipótesis**: El problema está en la configuración local, no en el servidor VPN

### 🧪 Pruebas Realizadas
#### 1. Verificación de Conectividad Básica
- ✅ Ping a `k8sraspi.myddns.me`: Funciona correctamente (12ms)
- ✅ Sin procesos VPN activos inicialmente

#### 2. Activación de VPN Original
- **Comando**: `sudo openvpn --config raspi-udp.ovpn --daemon`
- **Resultado**: VPN se activa pero interrumpe comunicación con asistente
- **Observación**: Usuario mantiene acceso a internet, pero asistente pierde conexión

#### 3. Prueba en Modo Interactivo
- **Comando**: `sudo openvpn --config raspi-udp.ovpn --verb 3`
- **Estado**: En progreso - esperando confirmación de comportamiento

#### 4. Prueba Controlada de Comunicación ⚠️ CONFIRMADO
- **Método**: Test de conectividad antes y durante activación VPN
- **Resultado**: ✅ VPN funciona correctamente, pero interrumpe comunicación con asistente
- **Confirmación**: Usuario tuvo que detener VPN para recuperar comunicación
- **Conclusión**: La VPN redirige todo el tráfico, incluyendo conexión SSH del asistente
- **Error Técnico**: `ConnectError: [unknown] Network disconnected` - confirma interrupción de red

### 🎯 Plan de Pruebas Sistemáticas
1. **Confirmar comportamiento de desconexión** cuando VPN se activa
2. **Verificar configuración de rutas** antes y después de activar VPN
3. **Probar configuración split-tunnel** si es necesario
4. **Comparar con configuración de Carlos** (pendiente)

### 📋 Tareas Pendientes
- [x] Confirmar si la desconexión es real o por impaciencia del usuario
- [x] Solicitar configuración VPN de Carlos para comparación
- [x] Probar configuración split-tunnel si la original no es adecuada
- [x] Documentar solución final

### ✅ SOLUCIÓN VPN ENCONTRADA - 2025-01-24
#### Configuración Split-Tunnel Mejorada
- **Archivo**: `raspi-udp-split-improved.ovpn`
- **Estado**: ✅ FUNCIONANDO PERFECTAMENTE
- **Características**:
  - `route-nopull` - Evita redirección completa de tráfico
  - Rutas específicas del cluster: `192.168.1.0/24`, `10.244.0.0/16`, `10.96.0.0/12`
  - DNS explícito: `8.8.8.8`, `8.8.4.4`
  - Mantiene conectividad a internet mientras accede al cluster

#### Verificaciones Exitosas
- ✅ Conectividad a internet mantenida (ping a Google)
- ✅ Acceso al cluster funcionando (ping a k8sraspi.myddns.me)
- ✅ SSH al cluster funcionando (acceso completo)
- ✅ Comunicación con asistente mantenida
- ✅ kubectl funcionando (acceso completo al cluster)

#### Verificación de Vaultwarden y Helm - 2025-01-24
##### Estado de Vaultwarden
- **Pod**: `vaultwarden-b58b8c66c-xj6rm` - Running (14h)
- **Servicios**: 
  - `vaultwarden` (ClusterIP: 10.98.64.146:80)
  - `vaultwarden-nodeport` (NodePort: 30080)
- **Acceso Web**: ✅ Funcionando en http://localhost:8080 (túnel SSH)

##### Verificación de Helm
- **Helm local**: ✅ Instalado (v3.14.3)
- **Helm en cluster**: ❌ No instalado
- **Conclusión**: Vaultwarden se instaló con `kubectl apply`, NO con Helm
- **Razón**: Se optó por instalación manual para mayor control y simplicidad

#### Scripts Creados
- **`connect-vpn.sh`**: Script automatizado para conectar VPN con verificaciones
- **Uso**: `./connect-vpn.sh`
- **Funcionalidades**: Verificación de conectividad, activación VPN, validación de acceso

- **`access-vaultwarden-vpn.sh`**: Script para acceder a Vaultwarden usando VPN
- **Uso**: `./access-vaultwarden-vpn.sh`
- **Funcionalidades**: Verificación de VPN, estado de Vaultwarden, túnel SSH, acceso web

#### Comandos de Uso
```bash
# Conectar VPN
./connect-vpn.sh

# Acceder a Vaultwarden (requiere VPN activa)
./access-vaultwarden-vpn.sh

# Conectar manualmente
sudo openvpn --config raspi-udp-split-improved.ovpn --daemon

# Desconectar VPN
sudo pkill openvpn

# Verificar estado
ps aux | grep openvpn
```

### 🔐 Consideraciones de Seguridad
- **Recordatorio**: Verificar información sensible antes de cualquier commit/push
- **Archivos sensibles**: `.ovpn`, certificados, claves privadas
- **Documentación**: Usar placeholders para datos sensibles

### 🎯 CONCLUSIONES Y LACITO FINAL - 2025-01-24

#### ✅ Objetivos Cumplidos
1. **VPN Funcional**: ✅ Configuración split-tunnel que mantiene conectividad
2. **Acceso a Vaultwarden**: ✅ Web interface accesible vía túnel SSH
3. **Verificación de Instalación**: ✅ Confirmado que se usó kubectl apply, no Helm
4. **Scripts Automatizados**: ✅ Dos scripts funcionales para VPN y acceso

#### 🔧 Soluciones Implementadas
- **Configuración VPN**: `raspi-udp-split-improved.ovpn` con rutas específicas
- **Script de Conexión**: `connect-vpn.sh` con verificaciones automáticas
- **Script de Acceso**: `access-vaultwarden-vpn.sh` para acceso web
- **Documentación**: Actualizada con todos los hallazgos y soluciones

#### 📊 Estado Final
- **VPN**: ✅ Funcionando perfectamente
- **Cluster**: ✅ Acceso completo vía SSH y kubectl
- **Vaultwarden**: ✅ Accesible en http://localhost:8080
- **Comunicación**: ✅ Mantenida con asistente
- **Scripts**: ✅ Automatizados y funcionales

#### 🎉 Resultado Final
**Cluster RasPi completamente funcional con VPN estable y Vaultwarden accesible.**
**Trabajo documentado y automatizado para uso futuro.**

---
