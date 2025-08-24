---
*Última actualización: 2025-01-24*
*Estado: Vaultwarden usando 7GB en node2*

## 📊 Estado Actual del Almacenamiento

### Uso Real por Nodo

#### Node1 (Master)
- **Partición 15GB**: Sistema y logs de Kubernetes
- **Partición 8GB**: Disponible para futuros servicios
- **Estado**: ✅ Funcionando correctamente

#### Node2 (Worker)
- **Partición 7GB**: **Vaultwarden usando 7GB**
- **Estado**: ✅ Vaultwarden funcionando correctamente
- **Servicio**: Servidor de contraseñas operativo

### Verificación de Uso Actual
```bash
# Verificar uso en node2 (Vaultwarden)
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 6022 "df -h /mnt/sdcard/7gb"

# Verificar datos de Vaultwarden
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem carlos@k8sraspi.myddns.me -p 6022 "du -sh /mnt/sdcard/7gb/vaultwarden/*"
```

### Próximos Servicios
- **Node1**: 8GB disponibles para futuros servicios
- **Node2**: 7GB usados por Vaultwarden
- **Recomendación**: Usar Node1 para nuevos servicios
