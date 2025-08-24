# Diario de Trabajo - Cluster RasPi

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

#### Patrones de Trabajo del Usuario
- **Experiencia**: 25 años en sistemas e infraestructura cloud
- **Enfoque**: Metódico, prefiere documentación completa
- **Gestión de configuraciones**: Mantiene múltiples contextos kubectl organizados
- **Seguridad**: Utiliza VPN para acceso remoto, configuración de certificados
- **Resolución de problemas**: Identifica rápidamente problemas de conectividad
- **Documentación**: Mantiene información técnica detallada en múltiples fuentes

### 📝 Próximos Pasos
1. **Configurar kubectl con SSH proxy**: Para acceso directo desde local
2. **Investigación de servidores de contraseñas**: Continuar con opciones disponibles
3. **Implementar Vaultwarden**: Una vez configurado el acceso kubectl
4. **Configurar persistencia**: Usar espacio libre de MicroSD

### 🏷️ Tags
#configuracion #kubectl #vpn #analisis-proyecto #limpieza-entorno #problema-conectividad #split-tunnel #ssh-directo #resolucion-conectividad
