#!/bin/bash

# Script para acceder a Vaultwarden en el cluster RasPi
# Uso: ./access-vaultwarden.sh

echo "Configurando acceso a Vaultwarden..."

# Matar cualquier proceso anterior
pkill -f "ssh.*8080.*vaultwarden" 2>/dev/null

# Crear túnel SSH para acceder a Vaultwarden via NodePort
echo "Creando túnel SSH..."
ssh -o IdentitiesOnly=yes -i ~/.ssh/raspi.pem -L 8080:localhost:30080 carlos@k8sraspi.myddns.me -p 6022 -N &
SSH_PID=$!

# Esperar a que el túnel se establezca
sleep 3

# Verificar que el túnel funciona
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "✅ Vaultwarden accesible en: http://localhost:8080"
    echo "🌐 Abre tu navegador y ve a: http://localhost:8080"
    echo ""
    echo "Para detener el acceso, ejecuta: kill $SSH_PID"
    echo "O presiona Ctrl+C en este terminal"
    
    # Mantener el script corriendo
    wait $SSH_PID
else
    echo "❌ Error: No se puede acceder a Vaultwarden"
    kill $SSH_PID 2>/dev/null
    exit 1
fi
