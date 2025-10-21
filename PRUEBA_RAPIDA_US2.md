# 🔑 Prueba Rápida - Historia #2: Cambio de Contraseña

## ⚡ Prueba en 3 Minutos

### **1. Iniciar Backend** (30 segundos)

```bash
cd backend
npm start
```

---

### **2. Probar Endpoint** (1 minuto)

```bash
# Test con contraseña débil (debería fallar)
curl -X POST http://localhost:3000/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test123",
    "currentPassword": "oldpass",
    "newPassword": "weak"
  }'
```

**Esperado:** Error "La contraseña debe tener al menos 8 caracteres"

```bash
# Test con contraseña fuerte (debería funcionar si el usuario existe)
curl -X POST http://localhost:3000/auth/change-password \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID_REAL",
    "currentPassword": "contraseñaActual",
    "newPassword": "NuevaPass123!"
  }'
```

---

### **3. Ejecutar App Flutter** (30 segundos)

```bash
flutter run
```

---

### **4. Probar en la App** (1 minuto)

1. Login
2. Navegar a "Cambiar Contraseña"
3. Ingresar contraseña actual
4. Ingresar nueva contraseña fuerte
5. Confirmar
6. Verificar diálogo de éxito
7. Verificar logout automático

---

## 🧪 Tests de Validación

### **Test 1: Contraseña Corta** ❌
```
Input: "Pass1!"
Expected: "Falta: Mínimo 8 caracteres"
```

### **Test 2: Sin Mayúscula** ❌
```
Input: "password123!"
Expected: "Falta: Una mayúscula"
```

### **Test 3: Sin Número** ❌
```
Input: "Password!"
Expected: "Falta: Un número"
```

### **Test 4: Sin Carácter Especial** ❌
```
Input: "Password123"
Expected: "Falta: Un carácter especial"
```

### **Test 5: No Coinciden** ❌
```
Nueva: "NewPass123!"
Confirmar: "DifferentPass123!"
Expected: "Las contraseñas no coinciden"
```

### **Test 6: Contraseña Fuerte** ✅
```
Input: "NewPass123!"
Expected: 
- Indicador verde "Fuerte"
- Permite enviar
- Diálogo de éxito
- Logout automático
```

---

## 📱 Características a Verificar

### **Card de Requisitos**
- [ ] Fondo azul claro
- [ ] Icono de seguridad
- [ ] 4 requisitos con checkmarks
- [ ] Texto legible

### **Campos de Contraseña**
- [ ] 3 campos presentes
- [ ] Botón mostrar/ocultar en cada uno
- [ ] Icono distinto en cada campo
- [ ] Contraseña oculta por defecto

### **Indicador de Fortaleza**
- [ ] Aparece al escribir
- [ ] Barra de progreso visual
- [ ] Color cambia (rojo → naranja → verde)
- [ ] Texto cambia (Débil → Media → Fuerte)

### **Validaciones**
- [ ] Valida contraseña vacía
- [ ] Valida < 8 caracteres
- [ ] Valida sin mayúscula
- [ ] Valida sin número
- [ ] Valida sin especial
- [ ] Valida confirmación diferente

### **Diálogo de Éxito**
- [ ] Aparece después de cambio exitoso
- [ ] Icono verde de check
- [ ] Título "Contraseña Actualizada"
- [ ] Mensaje de reinicio de sesión
- [ ] Card azul informativo
- [ ] Botón "Aceptar"

### **Flujo Completo**
- [ ] Botón se deshabilita durante proceso
- [ ] Muestra loading
- [ ] Muestra diálogo de éxito
- [ ] Cierra sesión automáticamente
- [ ] Redirige a login

---

## 🐛 Troubleshooting

### **Error: "Usuario no encontrado"**
```
Solución: Asegúrate de usar un userId válido de la BD
```

### **Error: "Contraseña actual incorrecta"**
```
Solución: Verifica la contraseña actual del usuario en la BD
```

### **La vista no muestra el indicador de fortaleza**
```
Solución: Empieza a escribir en el campo "Nueva Contraseña"
```

### **No se cierra la sesión después del cambio**
```
Solución: Verifica que authViewModel.logout() se ejecuta en el diálogo
```

---

## ✅ Checklist Rápido

- [ ] Backend inicia sin errores
- [ ] Endpoint POST /auth/change-password funciona
- [ ] Flutter app se ejecuta
- [ ] Vista de cambio de contraseña se muestra
- [ ] Card de requisitos es visible
- [ ] 3 campos con toggle funcionan
- [ ] Indicador de fortaleza aparece
- [ ] Validaciones funcionan
- [ ] Diálogo de éxito aparece
- [ ] Logout automático funciona

---

## 🎯 Contraseñas de Prueba

### **Contraseñas Débiles (para probar validaciones)**
```
"abc" - Muy corta
"password" - Sin mayúscula, número, especial
"PASSWORD" - Sin minúscula, número, especial  
"Pass123" - Falta especial
"Password!" - Falta número
```

### **Contraseñas Fuertes (deberían pasar)**
```
"Password123!"
"MyPass456@"
"Secure2024#"
"Test123$"
```

---

**¡Listo para probar!** 🔑✅

