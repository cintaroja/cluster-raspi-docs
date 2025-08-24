# Credenciales Vaultwarden - Cluster RasPi

## Acceso Web
- **URL**: http://localhost:8080
- **Estado**: ✅ Funcionando

## Credenciales de Administración
- **URL Admin**: http://localhost:8080/admin
- **ADMIN_TOKEN**: `[CONFIGURAR_TOKEN_SEGURO]`

## Configuración Actual
- **Registro de usuarios**: ✅ Habilitado
- **Organización**: Cluster RasPi
- **Almacenamiento**: 2GB en `/mnt/sdcard/7gb/vaultwarden`
- **Nodo**: node2 (worker)

## Pasos para Configurar

### 1. Crear Usuario Administrador
1. Abrir http://localhost:8080
2. Hacer clic en "Create Account"
3. Crear cuenta con email y contraseña maestra

### 2. Acceder al Panel de Administración
1. Ir a http://localhost:8080/admin
2. Introducir el ADMIN_TOKEN: `[CONFIGURAR_TOKEN_SEGURO]`

### 3. Configurar Organización (Opcional)
- Crear organización para familia/amigos
- Invitar usuarios por email

## Notas de Seguridad
- El ADMIN_TOKEN actual es un token aleatorio (no hash Argon2)
- Para producción, considerar generar hash Argon2
- El acceso actual es via túnel SSH (seguro)

## Comandos Útiles
```bash
# Acceder a Vaultwarden
./access-vaultwarden.sh

# Ver logs
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl logs -n vaultwarden deployment/vaultwarden"

# Ver estado del pod
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 5022 "kubectl get pods -n vaultwarden"
```
