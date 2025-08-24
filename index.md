# Cluster RasPi - Documentación del Proyecto

## 🎯 Resumen del Proyecto

Este proyecto implementa un **servidor de contraseñas Vaultwarden** en un cluster Kubernetes de Raspberry Pi, diseñado para uso familiar y de amigos.

## ✅ Estado Actual

**Vaultwarden completamente operativo**:
- 🚀 Servidor funcionando en worker node (node2)
- 💾 Almacenamiento persistente de 2GB configurado
- 🌐 Acceso web disponible en http://localhost:8080
- 👥 Registro de usuarios habilitado para familia/amigos
- 🔐 Panel de administración configurado

## 📚 Documentación Disponible

### Para Desarrolladores
- [Diario de Trabajo](diario-trabajo.md) - Historial completo de trabajo
- [Estado del Proyecto](estado-proyecto.md) - Estado actual detallado
- [Observaciones IA](observaciones-ia.md) - Perfil del usuario y patrones

### Guías Técnicas
- [Análisis de Servidores de Contraseñas](guias-tecnicas/servidores-contrasenas-opciones.md)
- [Estado de Almacenamiento](guias-tecnicas/estado-almacenamiento.md)

### Para Usuarios
- [Credenciales Vaultwarden](vaultwarden-credentials.md) - Acceso y configuración

## 🚀 Acceso Rápido

### Para Usuarios
1. **Acceder a Vaultwarden**: http://localhost:8080
2. **Crear cuenta**: Hacer clic en "Create Account"
3. **Usar apps móviles/desktop**: Configurar con la URL del servidor

### Para Administradores
1. **Acceso al cluster**: `ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022`
2. **Panel admin Vaultwarden**: http://localhost:8080/admin
3. **Token admin**: `[CONFIGURAR_TOKEN_SEGURO]`

---

**Última actualización**: 2025-08-24  
**Estado**: ✅ Vaultwarden operativo y funcional
