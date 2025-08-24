# Análisis: Acceso Público a Vaultwarden

## 🎯 Objetivo
Hacer Vaultwarden accesible desde cualquier navegador o app móvil (Bitwarden/Vaultwarden) sin necesidad de túnel SSH.

## 📊 Estado Actual

### Infraestructura Disponible
- **Cluster**: 2 nodos Raspberry Pi (192.168.1.49, 192.168.1.52)
- **DNS**: `k8sraspi.myddns.me` (88.7.208.182)
- **VPN**: Funcionando (split-tunnel)
- **Vaultwarden**: NodePort 30080, ClusterIP 10.98.64.146

### Limitaciones Actuales
- ❌ No hay Ingress Controller
- ❌ No hay LoadBalancer
- ❌ Solo accesible vía túnel SSH local
- ❌ Sin certificados SSL/TLS

## 🔧 Opciones de Implementación

### Opción 1: Ingress Controller + Let's Encrypt (Recomendada)

#### Ventajas
- ✅ Acceso HTTPS automático
- ✅ Certificados SSL gratuitos
- ✅ Configuración estándar de Kubernetes
- ✅ Escalable para futuros servicios

#### Implementación
```bash
# 1. Instalar NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml

# 2. Instalar cert-manager para Let's Encrypt
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml

# 3. Configurar Ingress para Vaultwarden
```

#### Configuración Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vaultwarden-ingress
  namespace: vaultwarden
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - vaultwarden.k8sraspi.myddns.me
    secretName: vaultwarden-tls
  rules:
  - host: vaultwarden.k8sraspi.myddns.me
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: vaultwarden
            port:
              number: 80
```

### Opción 2: Reverse Proxy (Traefik)

#### Ventajas
- ✅ Más ligero que NGINX
- ✅ Configuración automática de certificados
- ✅ Integración nativa con Let's Encrypt

#### Implementación
```bash
# Instalar Traefik con Helm
helm repo add traefik https://traefik.github.io/charts
helm install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace \
  --set ingressRoute.dashboard.enabled=true
```

### Opción 3: Configuración Manual (Port Forwarding)

#### Ventajas
- ✅ Implementación rápida
- ✅ Sin dependencias adicionales
- ✅ Control total

#### Implementación
```bash
# 1. Configurar port forwarding en router
# Puerto 443 -> 192.168.1.52:30080

# 2. Configurar DNS
# vaultwarden.k8sraspi.myddns.me -> 88.7.208.182

# 3. Configurar certificado SSL manual
```

### Opción 4: Cloudflare Tunnel (Más Segura)

#### Ventajas
- ✅ No requiere abrir puertos
- ✅ Certificados SSL automáticos
- ✅ Protección DDoS incluida
- ✅ Acceso desde cualquier lugar

#### Implementación
```bash
# 1. Instalar cloudflared en el cluster
# 2. Configurar tunnel a Vaultwarden
# 3. Configurar DNS en Cloudflare
```

## 🔒 Consideraciones de Seguridad

### Requisitos Mínimos
- ✅ HTTPS obligatorio
- ✅ Certificados SSL válidos
- ✅ Headers de seguridad
- ✅ Rate limiting
- ✅ Logs de acceso

### Configuraciones Recomendadas
```yaml
# Headers de seguridad para Vaultwarden
nginx.ingress.kubernetes.io/configuration-snippet: |
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-XSS-Protection "1; mode=block" always;
  add_header Referrer-Policy "strict-origin-when-cross-origin" always;
```

## 📱 Configuración de Apps Móviles

### Bitwarden/Vaultwarden Apps
- **URL del servidor**: `https://vaultwarden.k8sraspi.myddns.me`
- **Puerto**: 443 (HTTPS)
- **Certificado**: Let's Encrypt automático

### Configuración de Dominio
```
vaultwarden.k8sraspi.myddns.me -> 88.7.208.182:443
```

## 🎯 Recomendación

### Opción Prioritaria: Ingress Controller + Let's Encrypt
1. **Fase 1**: Instalar NGINX Ingress Controller
2. **Fase 2**: Configurar cert-manager
3. **Fase 3**: Crear Ingress para Vaultwarden
4. **Fase 4**: Configurar DNS y certificados
5. **Fase 5**: Probar acceso desde apps móviles

### Plan de Implementación
```bash
# Día 1: Instalación de infraestructura
# Día 2: Configuración de certificados
# Día 3: Pruebas y ajustes
# Día 4: Documentación y configuración de apps
```

## 📋 Checklist de Implementación

- [ ] Instalar Ingress Controller
- [ ] Configurar cert-manager
- [ ] Crear Ingress para Vaultwarden
- [ ] Configurar DNS (subdominio)
- [ ] Verificar certificados SSL
- [ ] Probar acceso web
- [ ] Configurar apps móviles
- [ ] Documentar configuración
- [ ] Configurar backup de certificados

---
*Análisis creado: 2025-01-24*
*Estado: Acceso VPN funcional, acceso público pendiente*

## 🔍 Análisis Práctico - Infraestructura Actual

### Verificaciones Realizadas
- ✅ Cluster funcionando (2 nodos Raspberry Pi)
- ✅ Vaultwarden operativo (NodePort 30080)
- ✅ VPN split-tunnel funcional para acceso remoto
- ✅ Acceso web funcionando vía túnel SSH (localhost:8080)
- ❌ Puerto 30080 no expuesto externamente
- ❌ No hay Ingress Controller instalado
- ✅ DNS `k8sraspi.myddns.me` funcionando

### Opciones Prácticas (Ordenadas por Facilidad)

#### 1. **Opción Rápida: Port Forwarding en Router**
**Tiempo estimado**: 30 minutos
**Requisitos**: Acceso al router

```bash
# Configurar en router:
# Puerto 443 -> 192.168.1.52:30080
# Puerto 80 -> 192.168.1.52:30080 (redirect a 443)
```

**Ventajas**:
- ✅ Implementación inmediata
- ✅ Sin cambios en cluster
- ✅ Control total

**Desventajas**:
- ❌ Sin HTTPS automático
- ❌ Requiere configuración manual de certificados

#### 2. **Opción Recomendada: NGINX Ingress + Let's Encrypt**
**Tiempo estimado**: 2-3 horas
**Requisitos**: Acceso al cluster + DNS

```bash
# 1. Instalar NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml

# 2. Configurar NodePort para Ingress
kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec":{"type":"NodePort"}}'

# 3. Configurar port forwarding en router
# Puerto 443 -> 192.168.1.49:NodePort
```

#### 3. **Opción Avanzada: Cloudflare Tunnel**
**Tiempo estimado**: 1-2 horas
**Requisitos**: Cuenta Cloudflare gratuita

```bash
# 1. Instalar cloudflared en el cluster
# 2. Configurar tunnel a Vaultwarden
# 3. Configurar DNS en Cloudflare
```

### 🎯 Recomendación Inmediata

**Para acceso rápido**: Opción 1 (Port Forwarding)
**Para solución completa**: Opción 2 (NGINX Ingress)

### 📋 Plan de Acción Sugerido

#### Fase 1: Acceso Rápido (Hoy)
1. Configurar port forwarding en router (443 -> 192.168.1.52:30080)
2. Probar acceso desde navegador
3. Configurar apps móviles

#### Fase 2: Solución Completa (Próxima sesión)
1. Instalar NGINX Ingress Controller
2. Configurar cert-manager
3. Crear Ingress con HTTPS
4. Migrar a solución completa

### 🔧 Comandos de Verificación

```bash
# Verificar que Vaultwarden está funcionando
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get svc -n vaultwarden"

# Verificar puertos abiertos
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "sudo netstat -tlnp | grep -E ':(80|443|30080)'"

# Probar acceso directo al NodePort
curl -I http://192.168.1.52:30080
```
