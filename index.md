# Cluster RasPi - Documentación del Proyecto

## 🎯 Resumen del Proyecto

Este proyecto implementa un **servidor de contraseñas Vaultwarden** en un cluster Kubernetes de Raspberry Pi, diseñado para uso familiar y de amigos.

## ✅ Estado Actual - COMPLETAMENTE OPERATIVO

**Vaultwarden completamente operativo**:
- 🚀 Servidor funcionando en worker node (node2)
- 💾 Almacenamiento persistente de 7GB configurado
- 🌐 Acceso web disponible en http://localhost:8080
- 👥 Registro de usuarios habilitado para familia/amigos
- 🔐 Panel de administración configurado
- 🔗 **VPN funcional** para acceso remoto seguro
- 📁 **Documentación organizada** en dos repositorios específicos

## 📚 Documentación Disponible

### 📋 Resúmenes Ejecutivos
- [Resumen Ejecutivo Actualizado](RESUMEN-EJECUTIVO-ACTUALIZADO.md) - Estado completo del proyecto
- [Resumen Acceso Público](RESUMEN-ACCESO-PUBLICO.md) - Análisis de opciones de acceso público
- [Resumen VPN y Vaultwarden](RESUMEN-VPN-VAULTWARDEN.md) - Configuración VPN y acceso

### 📖 Para Desarrolladores
- [Diario de Trabajo](diario-trabajo.md) - Historial completo de trabajo y decisiones
- [Estado del Proyecto](estado-proyecto.md) - Estado actual detallado y arquitectura
- [Observaciones IA](observaciones-ia.md) - Perfil del usuario y patrones de trabajo

### 🔧 Guías Técnicas
- [Comandos y Consultas](guias-tecnicas/comandos-consultas-logs.md) - Comandos útiles para diagnóstico y monitoreo
- [Análisis de Servidores de Contraseñas](guias-tecnicas/servidores-contrasenas-opciones.md) - Comparación de opciones
- [Estado de Almacenamiento](guias-tecnicas/estado-almacenamiento.md) - Análisis detallado de almacenamiento
- [Acceso Público Vaultwarden](guias-tecnicas/acceso-publico-vaultwarden.md) - Opciones para acceso público

### 👥 Para Usuarios
- [Credenciales Vaultwarden](vaultwarden-credentials.md) - Acceso y configuración
- [README Principal](README.md) - Documentación completa del proyecto

## 🚀 Acceso Rápido

### Para Usuarios
1. **Acceder a Vaultwarden**: http://localhost:8080
2. **Crear cuenta**: Hacer clic en "Create Account"
3. **Usar apps móviles/desktop**: Configurar con la URL del servidor

### Para Administradores
1. **Conectar VPN**: Usar configuración split-tunnel
2. **Acceso al cluster**: `ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022`
3. **Panel admin Vaultwarden**: http://localhost:8080/admin
4. **Token admin**: `[CONFIGURAR_TOKEN_SEGURO]`

## 🏗️ Arquitectura del Sistema

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

## 🔒 Seguridad Implementada

- **VPN Split-tunnel**: Acceso remoto sin perder conectividad
- **SSH en puertos no estándar**: 5022 (master), 6022 (worker)
- **Tokens seguros**: ADMIN_TOKEN renovado y protegido
- **Documentación limpia**: Sin información sensible en repositorio público

## 📁 Organización del Proyecto

- **`cluster-raspi-docs/`**: Documentación pública (este repositorio)
- **`doc/`**: Documentación interna con información sensible
- **`scripts/`**: Scripts de automatización
- **`manifests/`**: Archivos de configuración Kubernetes
- **`summaries/`**: Resúmenes ejecutivos

---

**Última actualización**: 2025-01-24  
**Estado**: ✅ Cluster RasPi completamente operativo con Vaultwarden funcionando
