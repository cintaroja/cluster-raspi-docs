# Diario de Trabajo - Cluster RasPi

## 2025-08-24 - Aplicación de Feedback de Carlos en PR

### 🔧 Mejoras Aplicadas según Feedback

**Carlos revisó la PR y proporcionó excelente feedback técnico**:

1. **Eliminación de nodeSelector**:
   - **Problema**: nodeSelector innecesario ya que el master está tainted
   - **Solución**: Eliminado para permitir escalabilidad futura
   - **Beneficio**: Vaultwarden se instala automáticamente en node2

2. **Eliminación de CPU limits**:
   - **Problema**: CPU limits pueden causar throttling y problemas de performance
   - **Solución**: Eliminados siguiendo mejores prácticas de Kubernetes
   - **Beneficio**: Mejor performance y estabilidad

3. **Aumento de almacenamiento a 7GB**:
   - **Problema**: Solo se usaban 2GB de los 7GB disponibles en la partición
   - **Solución**: Reservar toda la partición para Vaultwarden
   - **Beneficio**: Máximo aprovechamiento del espacio disponible

**Archivos modificados**:
- `vaultwarden-deployment.yaml`: Eliminado nodeSelector y CPU limits
- `vaultwarden-pv.yaml`: Aumentado storage a 7Gi
- `vaultwarden-pvc.yaml`: Aumentado requests a 7Gi
- `README.md`: Documentación actualizada

**Estado**: ✅ Cambios aplicados y subidos a la PR

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

---

## 📅 2025-01-24 - Configuración VPN y Organización de Documentación

### 🔧 Configuración VPN Split-Tunnel ✅
- **Problema identificado**: VPN original cortaba toda la conectividad
- **Solución**: Configuración split-tunnel mejorada
- **Archivo**: `raspi-udp-split-improved.ovpn`
- **Configuración**:
  ```bash
  route-nopull
  route 192.168.1.0 255.255.255.0
  route 10.244.0.0 255.255.0.0
  route 10.96.0.0 255.240.0.0
  route 88.7.208.182 255.255.255.255
  ```
- **Resultado**: Acceso al cluster sin perder conectividad a internet

### 🛠️ Scripts de Automatización ✅
- **`connect-vpn.sh`**: Script para conectar VPN con verificaciones
- **`access-vaultwarden-vpn.sh`**: Script para acceder a Vaultwarden vía VPN
- **Funcionalidades**:
  - Verificación de conectividad pre/post VPN
  - Creación automática de túnel SSH
  - Verificación de estado de servicios

### 📁 Organización de Documentación ✅
- **Problema**: Duplicación entre carpetas `doc/` y `docs/`
- **Solución**: Estructura clara con dos repositorios específicos

#### Repositorio `doc/` (Local - Trabajo Interno)
- **Propósito**: Documentación interna con información sensible
- **Contenido**: Diario detallado, credenciales, configuraciones sensibles
- **Seguridad**: Puede contener información sensible, NO subir a remotos

#### Repositorio `cluster-raspi-docs/` (GitHub - Documentación Pública)
- **Propósito**: Documentación técnica limpia para compartir
- **Contenido**: Guías técnicas, scripts, resúmenes ejecutivos
- **Seguridad**: Sin información sensible, usa placeholders

### 🔒 Seguridad y Credenciales ✅
- **Problema**: Exposición de ADMIN_TOKEN en documentación pública
- **Solución**: 
  - Renovación de tokens
  - Uso de placeholders: `[CONFIGURAR_TOKEN_SEGURO]`
  - `.gitignore` estricto para archivos sensibles
- **Verificación**: Documentación pública sin información sensible

### 📋 Refactorización de Estructura ✅
- **Carpetas creadas**:
  - `scripts/`: Scripts de automatización
  - `configs/`: Configuraciones
  - `manifests/`: Manifiestos Kubernetes
  - `summaries/`: Resúmenes ejecutivos
- **READMEs**: Documentación específica para cada carpeta

### 🎯 Estado Final del Proyecto
- **Vaultwarden**: Funcionando en cluster RasPi
- **VPN**: Configuración split-tunnel operativa
- **Documentación**: Organizada en dos repositorios específicos
- **Seguridad**: Información sensible protegida
- **Scripts**: Automatización de tareas comunes

### 🏷️ Tags
#configuracion #kubectl #vpn #analisis-proyecto #limpieza-entorno #problema-conectividad #split-tunnel #ssh-directo #resolucion-conectividad #helm-local #vaultwarden #instalacion-exitosa #worker-node #almacenamiento-dedicado #vpn-split-tunnel #organizacion-documentacion #seguridad-credenciales #scripts-automatizacion #refactorizacion-estructura
