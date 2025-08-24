# Cluster RasPi - Servidor de Contraseñas Vaultwarden

## 🎯 Resumen del Proyecto

Este proyecto implementa un servidor de contraseñas **Vaultwarden** (compatible con Bitwarden) en un cluster Kubernetes de Raspberry Pi, diseñado para uso familiar y de amigos.

## ✅ Estado Actual

**Vaultwarden completamente operativo**:
- 🚀 Servidor funcionando en worker node (node2)
- 💾 Almacenamiento persistente de 2GB configurado
- 🌐 Acceso web disponible en http://localhost:8080
- 👥 Registro de usuarios habilitado para familia/amigos
- 🔐 Panel de administración configurado

## 🏗️ Arquitectura

```
Cluster RasPi
├── Master Node (node1)
│   ├── Kubernetes Control Plane
│   ├── Prometheus Stack (monitoring)
│   └── Gestión del cluster
└── Worker Node (node2)
    ├── Vaultwarden (servidor de contraseñas)
    └── Almacenamiento dedicado (7GB partition)
```

## 🚀 Acceso Rápido

### Para Usuarios
1. **Acceder a Vaultwarden**: http://localhost:8080
2. **Crear cuenta**: Hacer clic en "Create Account"
3. **Usar apps móviles/desktop**: Configurar con la URL del servidor

### Para Administradores
1. **Acceso al cluster**: `ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022`
2. **Panel admin Vaultwarden**: http://localhost:8080/admin
3. **Token admin**: `[CONFIGURAR_TOKEN_SEGURO]`

## 📁 Estructura del Proyecto

```
Cluster RasPi/
├── doc/                           # Documentación completa
│   ├── diario-trabajo.md          # Historial de trabajo
│   ├── estado-proyecto.md         # Estado actual
│   ├── observaciones-ia.md        # Perfil del usuario
│   └── guias-tecnicas/            # Guías técnicas
├── raspk8s/                       # Repositorio de infraestructura
├── vaultwarden-*.yaml            # Manifiestos Kubernetes
├── access-vaultwarden.sh         # Script de acceso
├── vaultwarden-credentials.md    # Credenciales
└── README.md                     # Este archivo
```

## 🔧 Configuración Técnica

### Requisitos
- Cluster Kubernetes en Raspberry Pi
- Acceso SSH a los nodos
- Helm (instalado localmente)

### Servicios Instalados
- **Vaultwarden**: Servidor de contraseñas
- **Prometheus/Grafana**: Monitoreo del cluster
- **cAdvisor**: Métricas de contenedores

### Almacenamiento
- **node1**: 15GB (sistema) + 8GB (disponible)
- **node2**: 7GB (Vaultwarden usa 2GB)

## 📚 Documentación

### Para Desarrolladores
- [Diario de Trabajo](doc/diario-trabajo.md) - Historial completo
- [Estado del Proyecto](doc/estado-proyecto.md) - Estado actual
- [Análisis de Opciones](doc/guias-tecnicas/servidores-contrasenas-opciones.md)

### Para Usuarios
- [Credenciales Vaultwarden](vaultwarden-credentials.md) - Acceso y configuración
- [Guía de Almacenamiento](doc/guias-tecnicas/estado-almacenamiento.md)

## 🛠️ Comandos Útiles

```bash
# Acceder a Vaultwarden
./access-vaultwarden.sh

# Ver estado del cluster
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -A"

# Ver logs de Vaultwarden
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl logs -n vaultwarden deployment/vaultwarden"
```

## 🔮 Próximos Pasos

### Prioridad Alta
- [ ] Organizar repositorios (infraestructura + documentación)
- [ ] Compartir documentación con compañero

### Prioridad Media
- [ ] Configurar acceso web seguro (HTTPS + Ingress)
- [ ] Configurar VPN para acceso remoto
- [ ] Implementar backup automático

### Prioridad Baja
- [ ] Integrar Vaultwarden con monitoring
- [ ] Optimizar recursos del cluster

## 🤝 Contribución

Este proyecto está diseñado para uso familiar. Para contribuir:
1. Revisar la documentación en `doc/`
2. Seguir las convenciones establecidas
3. Actualizar el diario de trabajo

## 📞 Contacto

Para soporte técnico o consultas sobre el cluster, revisar la documentación en `doc/` o contactar al administrador del sistema.

---

**Última actualización**: 2025-08-24  
**Estado**: ✅ Vaultwarden operativo y funcional
