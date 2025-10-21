# 🚀 Guía de Prueba Rápida - US#1

## ⚡ Prueba en 5 Minutos

### **1. Iniciar Backend** (1 min)

```bash
cd backend
npm start
```

Espera ver:
```
✅ Servidor ejecutándose en 0.0.0.0:3000
✅ MongoDB conectado
```

---

### **2. Probar Endpoint** (1 min)

Abre una nueva terminal:

```bash
# Registrar una sesión de prueba
curl -X POST http://localhost:3000/historial-sesiones \
  -H "Content-Type: application/json" \
  -d '{
    "usuarioId": "test123",
    "nombreUsuario": "Usuario Prueba",
    "rol": "Guardia",
    "direccionIp": "192.168.1.100",
    "dispositivoInfo": "Android Mobile"
  }'
```

Deberías recibir:
```json
{
  "success": true,
  "sesionId": "...",
  "message": "Inicio de sesión registrado exitosamente"
}
```

---

### **3. Verificar en MongoDB** (1 min)

```bash
# Obtener el historial
curl http://localhost:3000/historial-sesiones/usuario/test123
```

Deberías ver:
```json
{
  "success": true,
  "historial": [
    {
      "_id": "...",
      "usuarioId": "test123",
      "nombreUsuario": "Usuario Prueba",
      "rol": "Guardia",
      "sesionActiva": true,
      ...
    }
  ]
}
```

---

### **4. Ejecutar App Flutter** (1 min)

```bash
flutter pub get
flutter run
```

---

### **5. Navegar a la Vista** (1 min)

1. Abrir app
2. Login (si está configurado)
3. Menú → "Historial de Sesiones"
4. Ver la lista con tus sesiones

---

## 🧪 Pruebas Completas

### **Prueba 1: Registrar Sesión**
```bash
curl -X POST http://localhost:3000/historial-sesiones \
  -H "Content-Type: application/json" \
  -d '{
    "usuarioId": "user001",
    "nombreUsuario": "Juan Pérez",
    "rol": "Administrador",
    "direccionIp": "192.168.1.50",
    "dispositivoInfo": "iOS Mobile"
  }'
```

**Resultado esperado:** `{ "success": true, "sesionId": "..." }`

---

### **Prueba 2: Obtener Historial**
```bash
curl http://localhost:3000/historial-sesiones/usuario/user001
```

**Resultado esperado:** Array con 1 sesión activa

---

### **Prueba 3: Cerrar Sesión**
```bash
# Usa el sesionId del paso 1
curl -X PATCH http://localhost:3000/historial-sesiones/SESION_ID/cerrar \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraCierre": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }'
```

**Resultado esperado:** `{ "success": true, "message": "Cierre de sesión registrado" }`

---

### **Prueba 4: Verificar Sesión Cerrada**
```bash
curl http://localhost:3000/historial-sesiones/usuario/user001
```

**Resultado esperado:** Sesión con `sesionActiva: false`

---

### **Prueba 5: Obtener Estadísticas**
```bash
curl http://localhost:3000/historial-sesiones/estadisticas/user001
```

**Resultado esperado:**
```json
{
  "success": true,
  "estadisticas": {
    "totalSesiones": 1,
    "sesionesActivas": 0,
    "sesionesCerradas": 1,
    "ultimaSesion": {...}
  }
}
```

---

## 📱 Prueba en la App

### **Test Case 1: Vista Vacía**
1. Abrir app
2. Navegar a "Historial de Sesiones"
3. **Verificar:** Mensaje "No hay registros de sesiones"

### **Test Case 2: Registro Automático**
1. Hacer login en la app
2. Navegar a "Historial de Sesiones"
3. **Verificar:** Aparece sesión actual con chip verde "ACTIVA"

### **Test Case 3: Pull to Refresh**
1. En "Historial de Sesiones"
2. Hacer pull down
3. **Verificar:** Spinner de carga y datos actualizados

### **Test Case 4: Múltiples Sesiones**
1. Login/logout 3 veces
2. Navegar a "Historial de Sesiones"
3. **Verificar:** 
   - 3 sesiones en la lista
   - Última sesión en la parte superior
   - Sesiones anteriores con chip "CERRADA"

### **Test Case 5: Detalles de Sesión**
1. Ver una sesión en la lista
2. **Verificar muestra:**
   - ✅ Nombre y rol
   - ✅ Fecha y hora
   - ✅ Dirección IP
   - ✅ Información del dispositivo
   - ✅ "Hace X minutos/horas"

---

## ✅ Checklist de Verificación Rápida

- [ ] Backend inicia sin errores
- [ ] POST /historial-sesiones funciona
- [ ] GET /historial-sesiones/usuario/:id funciona
- [ ] PATCH /historial-sesiones/:id/cerrar funciona
- [ ] Flutter app se ejecuta sin errores
- [ ] Vista de historial se muestra
- [ ] Pull-to-refresh funciona
- [ ] Ordenamiento es correcto (más reciente primero)
- [ ] Colores distintivos (verde/gris)
- [ ] Estadísticas en header son correctas

---

## 🐛 Troubleshooting

### **Error: Cannot find module './binary'**
```bash
cd backend
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### **Error: ECONNREFUSED MongoDB**
- Verificar MONGODB_URI en `.env`
- Verificar conexión a internet
- Verificar que MongoDB Atlas esté accesible

### **Error: La vista no se muestra**
- Verificar que agregaste la ruta en el drawer/menú
- Verificar que registraste el ViewModel en Provider
- Verificar imports en main.dart

### **Los datos no se muestran**
- Verificar que el backend esté corriendo
- Verificar la URL en `api_config.dart`
- Verificar logs en consola de Flutter

---

## 📞 ¿Problemas?

Revisa los archivos de documentación:
- `IMPLEMENTACION_US1_COMPLETADA.md` - Documentación técnica
- `backend/FIX_ERROR_MONGOOSE.md` - Solución error mongoose
- `GUIA_IMPLEMENTACION_EXAMEN.md` - Guía paso a paso

---

**¡Listo para probar!** 🚀

