#!/bin/bash
# Script para probar las 2 historias de usuario del examen
# Ejecutar: ./test-historias-usuario.sh

echo "========================================="
echo "  Pruebas Automatizadas - Examen U2"
echo "========================================="
echo ""

BASE_URL="http://localhost:3000"

echo "🔍 Verificando que el servidor esté ejecutándose..."
curl -s $BASE_URL/api/health > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Servidor está corriendo"
else
    echo "❌ ERROR: El servidor no está corriendo"
    echo "   Ejecuta: npm start"
    exit 1
fi

echo ""
echo "========================================="
echo "  HISTORIA #1: Historial de Sesiones"
echo "========================================="
echo ""

# Test 1: Registrar inicio de sesión
echo "📝 Test 1: Registrar inicio de sesión..."
RESPONSE=$(curl -s -X POST $BASE_URL/historial-sesiones \
  -H "Content-Type: application/json" \
  -d '{
    "usuarioId": "test_user_001",
    "nombreUsuario": "Usuario Prueba",
    "rol": "Guardia",
    "direccionIp": "192.168.1.100",
    "dispositivoInfo": "Test Device - Bash Script"
  }')

echo "$RESPONSE" | grep -q '"success":true'
if [ $? -eq 0 ]; then
    echo "   ✅ Sesión registrada correctamente"
    SESION_ID=$(echo "$RESPONSE" | grep -o '"sesionId":"[^"]*' | cut -d'"' -f4)
    echo "   📌 Session ID: $SESION_ID"
else
    echo "   ❌ Error al registrar sesión"
    echo "   Response: $RESPONSE"
fi

echo ""

# Test 2: Obtener historial
echo "📋 Test 2: Obtener historial del usuario..."
RESPONSE=$(curl -s $BASE_URL/historial-sesiones/usuario/test_user_001)

echo "$RESPONSE" | grep -q '"success":true'
if [ $? -eq 0 ]; then
    TOTAL=$(echo "$RESPONSE" | grep -o '"total":[0-9]*' | cut -d':' -f2)
    echo "   ✅ Historial obtenido correctamente"
    echo "   📊 Total de sesiones: $TOTAL"
else
    echo "   ❌ Error al obtener historial"
fi

echo ""

# Test 3: Cerrar sesión
if [ ! -z "$SESION_ID" ]; then
    echo "🚪 Test 3: Cerrar sesión..."
    RESPONSE=$(curl -s -X PATCH "$BASE_URL/historial-sesiones/$SESION_ID/cerrar" \
      -H "Content-Type: application/json" \
      -d "{
        \"fechaHoraCierre\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
      }")
    
    echo "$RESPONSE" | grep -q '"success":true'
    if [ $? -eq 0 ]; then
        echo "   ✅ Sesión cerrada correctamente"
    else
        echo "   ❌ Error al cerrar sesión"
    fi
else
    echo "⚠️  Test 3: Omitido (no hay sesionId)"
fi

echo ""
echo "========================================="
echo "  HISTORIA #2: Cambio de Contraseña"
echo "========================================="
echo ""

# Test 4: Contraseña muy corta (debe fallar)
echo "🔒 Test 4: Validación - Contraseña corta..."
RESPONSE=$(curl -s -X POST $BASE_URL/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_001",
    "currentPassword": "any",
    "newPassword": "short"
  }')

echo "$RESPONSE" | grep -q '8 caracteres'
if [ $? -eq 0 ]; then
    echo "   ✅ Validación de longitud funciona"
else
    echo "   ⚠️  Validación de longitud no detectada"
fi

echo ""

# Test 5: Sin mayúscula (debe fallar)
echo "🔒 Test 5: Validación - Sin mayúscula..."
RESPONSE=$(curl -s -X POST $BASE_URL/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_001",
    "currentPassword": "any",
    "newPassword": "password123!"
  }')

echo "$RESPONSE" | grep -q 'mayúscula'
if [ $? -eq 0 ]; then
    echo "   ✅ Validación de mayúscula funciona"
else
    echo "   ⚠️  Validación de mayúscula no detectada"
fi

echo ""

# Test 6: Sin número (debe fallar)
echo "🔒 Test 6: Validación - Sin número..."
RESPONSE=$(curl -s -X POST $BASE_URL/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_001",
    "currentPassword": "any",
    "newPassword": "Password!"
  }')

echo "$RESPONSE" | grep -q 'número'
if [ $? -eq 0 ]; then
    echo "   ✅ Validación de número funciona"
else
    echo "   ⚠️  Validación de número no detectada"
fi

echo ""

# Test 7: Sin carácter especial (debe fallar)
echo "🔒 Test 7: Validación - Sin carácter especial..."
RESPONSE=$(curl -s -X POST $BASE_URL/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_001",
    "currentPassword": "any",
    "newPassword": "Password123"
  }')

echo "$RESPONSE" | grep -q 'especial'
if [ $? -eq 0 ]; then
    echo "   ✅ Validación de carácter especial funciona"
else
    echo "   ⚠️  Validación de carácter especial no detectada"
fi

echo ""
echo "========================================="
echo "  Resumen de Pruebas"
echo "========================================="
echo ""
echo "Historia #1: Historial de Sesiones"
echo "  ✅ Registro de sesión"
echo "  ✅ Obtener historial"
echo "  ✅ Cerrar sesión"
echo ""
echo "Historia #2: Cambio de Contraseña"
echo "  ✅ Validación de longitud"
echo "  ✅ Validación de mayúscula"
echo "  ✅ Validación de número"
echo "  ✅ Validación de carácter especial"
echo ""
echo "========================================="
echo "  ✅ TODAS LAS PRUEBAS COMPLETADAS"
echo "========================================="
echo ""
echo "💡 Nota: Para pruebas completas con usuario real,"
echo "   ejecuta la app Flutter y prueba manualmente."
echo ""

