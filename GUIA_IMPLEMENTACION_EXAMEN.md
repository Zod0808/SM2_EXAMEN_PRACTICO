# 🚀 Guía de Implementación - Examen Unidad II

## 📋 Información General

Esta guía proporciona los pasos detallados para implementar las dos historias de usuario seleccionadas para el examen de Sistemas Móviles II.

**Historias a Implementar:**
1. 🔐 Historial de Inicios de Sesión (17 horas - 5 SP)
2. 🔑 Cambio de Contraseña Personal (8 horas - 3 SP)

**Total**: 25 horas - 8 Story Points

---

## 🎯 Historia #1: Historial de Inicios de Sesión

### **Paso 1: Crear el Modelo de Datos (2 horas)**

1. Crear archivo `lib/models/historial_sesion_model.dart`:

```bash
touch lib/models/historial_sesion_model.dart
```

2. Copiar el código del modelo desde `Historia_Usuario_Examen_Unidad_II.md` (líneas 76-116)

3. Verificar que el modelo tenga:
   - Todos los campos requeridos
   - Métodos `fromJson()` y `toJson()`
   - Constructor con parámetros nombrados requeridos

### **Paso 2: Crear el Servicio (3 horas)**

1. Crear archivo `lib/services/historial_sesion_service.dart`:

```bash
touch lib/services/historial_sesion_service.dart
```

2. Implementar los tres métodos principales:
   - `registrarInicioSesion()` - Se llamará desde AuthViewModel al hacer login
   - `registrarCierreSesion()` - Se llamará al hacer logout
   - `obtenerHistorialUsuario()` - Obtiene todos los registros del usuario

3. Asegurarse de:
   - Importar `ApiService` existente
   - Manejar errores con try-catch
   - Usar `debugPrint` para logs

### **Paso 3: Crear el ViewModel (2 horas)**

1. Crear archivo `lib/viewmodels/historial_sesion_viewmodel.dart`:

```bash
touch lib/viewmodels/historial_sesion_viewmodel.dart
```

2. Extender `ChangeNotifier` para Provider
3. Implementar:
   - Estados: `_historial`, `_isLoading`, `_errorMessage`
   - Método `cargarHistorial()` con ordenamiento
   - Getters públicos

### **Paso 4: Crear la Vista (3 horas)**

1. Crear archivo `lib/views/user/historial_sesiones_view.dart`:

```bash
mkdir -p lib/views/user
touch lib/views/user/historial_sesiones_view.dart
```

2. Implementar UI con:
   - AppBar con título y botón refresh
   - Consumer<HistorialSesionViewModel>
   - ListView.builder para la lista
   - RefreshIndicator para pull-to-refresh
   - Estado de loading con CircularProgressIndicator
   - Estado vacío con mensaje e icono

3. Crear el widget `_buildSesionCard()`:
   - CircleAvatar con color según estado (verde/gris)
   - Título con nombre y rol
   - Subtitle con fecha, IP, dispositivo
   - Chip trailing con estado (ACTIVA/CERRADA)

### **Paso 5: Integrar con AuthViewModel (1.5 horas)**

1. Abrir `lib/viewmodels/auth_viewmodel.dart`

2. Importar el servicio:
```dart
import '../services/historial_sesion_service.dart';
```

3. Agregar instancia del servicio:
```dart
final HistorialSesionService _historialSesionService;
```

4. En el método `login()`, después de autenticación exitosa:
```dart
// Registrar inicio de sesión
await _historialSesionService.registrarInicioSesion(
  usuarioId: usuario.id,
  nombreUsuario: usuario.nombre,
  rol: usuario.rol,
  direccionIp: await _obtenerDireccionIP(),
  dispositivoInfo: await _obtenerInfoDispositivo(),
);
```

5. En el método `logout()`:
```dart
if (_sesionIdActual != null) {
  await _historialSesionService.registrarCierreSesion(_sesionIdActual!);
}
```

6. Implementar métodos auxiliares:
```dart
Future<String> _obtenerDireccionIP() async {
  // Obtener IP del dispositivo
  // Usar package: 'package:network_info_plus/network_info_plus.dart'
  return "192.168.1.100"; // Placeholder
}

Future<String> _obtenerInfoDispositivo() async {
  // Obtener info del dispositivo
  // Usar package: 'package:device_info_plus/device_info_plus.dart'
  return "Android 13"; // Placeholder
}
```

### **Paso 6: Registrar en Provider (0.5 horas)**

1. Abrir `lib/main.dart`

2. Agregar imports:
```dart
import 'viewmodels/historial_sesion_viewmodel.dart';
import 'services/historial_sesion_service.dart';
```

3. En MultiProvider, agregar:
```dart
ChangeNotifierProvider(
  create: (context) => HistorialSesionViewModel(
    context.read<HistorialSesionService>(),
    context.read<SessionService>(),
  ),
),
```

4. Registrar el servicio:
```dart
Provider(
  create: (_) => HistorialSesionService(
    context.read<ApiService>(),
  ),
),
```

### **Paso 7: Agregar Navegación (0.5 horas)**

1. En el drawer/menú principal, agregar:
```dart
ListTile(
  leading: Icon(Icons.history),
  title: Text('Historial de Sesiones'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorialSesionesView(),
      ),
    );
  },
),
```

### **Paso 8: Backend - Schema MongoDB (1 hora)**

1. Crear archivo `backend/schemas/historialSesionSchema.js`:

```bash
touch backend/schemas/historialSesionSchema.js
```

2. Definir el schema con mongoose (copiar de la documentación)

3. Crear índices:
```javascript
historialSesionSchema.index({ usuarioId: 1, fechaHoraInicio: -1 });
historialSesionSchema.index({ sesionActiva: 1 });
```

### **Paso 9: Backend - Routes (2.5 horas)**

1. Crear archivo `backend/routes/historialSesionRoutes.js`:

```bash
touch backend/routes/historialSesionRoutes.js
```

2. Implementar los 3 endpoints:
   - POST `/historial-sesiones` - Crear registro
   - PATCH `/historial-sesiones/:id/cerrar` - Cerrar sesión
   - GET `/historial-sesiones/usuario/:id` - Obtener historial

3. Agregar middleware de autenticación a todas las rutas

4. En `backend/index.js`, importar y registrar:
```javascript
const historialSesionRoutes = require('./routes/historialSesionRoutes');
app.use('/historial-sesiones', historialSesionRoutes);
```

### **Paso 10: Pruebas (2 horas)**

1. **Probar registro automático:**
   - Iniciar sesión
   - Verificar en MongoDB que se creó el registro
   - Verificar que tiene timestamp, IP, dispositivo

2. **Probar vista de historial:**
   - Navegar a "Historial de Sesiones"
   - Verificar que aparece el registro actual
   - Verificar indicador verde (sesión activa)

3. **Probar cierre de sesión:**
   - Hacer logout
   - Verificar en MongoDB que se actualizó `fechaHoraCierre`
   - Verificar que `sesionActiva = false`

4. **Probar múltiples sesiones:**
   - Login/logout 3 veces
   - Verificar que aparecen todos los registros
   - Verificar ordenamiento (más reciente primero)

5. **Probar pull-to-refresh:**
   - Hacer pull en la lista
   - Verificar que se actualizan los datos

---

## 🔑 Historia #2: Cambio de Contraseña Personal

### **Paso 1: Crear la Vista (4 horas)**

1. Crear archivo `lib/views/user/change_password_view.dart`:

```bash
touch lib/views/user/change_password_view.dart
```

2. Implementar UI completa con:
   - Scaffold con AppBar
   - Form con GlobalKey
   - Card informativo con requisitos de seguridad
   - 3 TextFormField:
     - Contraseña actual (con obscureText y toggle)
     - Nueva contraseña (con obscureText y toggle)
     - Confirmar contraseña (con obscureText y toggle)
   - CustomButton para "Cambiar Contraseña"

3. Implementar validaciones:
   - Método `_isPasswordStrong()` con regex:
     - Longitud >= 8
     - Al menos una mayúscula: `/[A-Z]/`
     - Al menos un número: `/[0-9]/`
     - Al menos un especial: `/[!@#$%^&*(),.?":{}|<>]/`

4. Implementar método `_changePassword()`:
   - Validar formulario
   - Llamar a `authViewModel.changePassword()`
   - Mostrar diálogo de éxito si todo ok
   - Llamar a `authViewModel.logout()` automáticamente
   - Mostrar SnackBar de error si falla

### **Paso 2: Extender AuthViewModel (1.5 horas)**

1. Abrir `lib/viewmodels/auth_viewmodel.dart`

2. Agregar método `changePassword()`:

```dart
Future<bool> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final userId = await _sessionService.getCurrentUserId();
    
    final response = await _apiService.post('/auth/change-password', {
      'userId': userId,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });

    if (response['success']) {
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Error al cambiar contraseña';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _errorMessage = 'Error: ${e.toString()}';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
```

### **Paso 3: Backend - Endpoint (2 horas)**

1. Abrir `backend/routes/authRoutes.js`

2. Agregar endpoint POST `/change-password`:

```javascript
router.post('/change-password', authMiddleware, async (req, res) => {
  try {
    const { userId, currentPassword, newPassword } = req.body;
    
    // Buscar usuario
    const usuario = await Usuario.findById(userId);
    if (!usuario) {
      return res.status(404).json({ 
        success: false, 
        message: 'Usuario no encontrado' 
      });
    }

    // Verificar contraseña actual
    const isPasswordValid = await bcrypt.compare(
      currentPassword, 
      usuario.password
    );
    if (!isPasswordValid) {
      return res.status(401).json({ 
        success: false, 
        message: 'Contraseña actual incorrecta' 
      });
    }

    // Validar nueva contraseña
    if (newPassword.length < 8) {
      return res.status(400).json({ 
        success: false, 
        message: 'La contraseña debe tener al menos 8 caracteres' 
      });
    }

    // Encriptar nueva contraseña
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    
    // Actualizar contraseña
    usuario.password = hashedPassword;
    await usuario.save();

    res.json({ 
      success: true, 
      message: 'Contraseña actualizada exitosamente' 
    });
  } catch (error) {
    res.status(500).json({ 
      success: false, 
      message: error.message 
    });
  }
});
```

### **Paso 4: Agregar Navegación (0.5 horas)**

1. En el menú de perfil/configuración, agregar:

```dart
ListTile(
  leading: Icon(Icons.lock_reset),
  title: Text('Cambiar Contraseña'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePasswordView(),
      ),
    );
  },
),
```

### **Paso 5: Pruebas Exhaustivas (2 horas)**

1. **Validaciones de contraseña:**
   - Probar contraseña < 8 chars → Error
   - Probar sin mayúscula → Error
   - Probar sin número → Error
   - Probar sin carácter especial → Error
   - Probar contraseña válida → Ok

2. **Confirmación:**
   - Probar confirmación diferente → Error "no coinciden"
   - Probar confirmación igual → Ok

3. **Contraseña actual:**
   - Probar contraseña actual incorrecta → Error 401
   - Probar contraseña actual correcta → Ok

4. **Flujo completo:**
   - Cambiar contraseña exitosamente
   - Verificar diálogo de confirmación
   - Verificar logout automático
   - Intentar login con contraseña antigua → Error
   - Login con contraseña nueva → Ok

5. **Toggle visibility:**
   - Probar botones de mostrar/ocultar en los 3 campos
   - Verificar que funcione correctamente

---

## 🧪 Testing Checklist Completo

### Historia #1: Historial de Sesiones

- [ ] Modelo se serializa correctamente (toJson/fromJson)
- [ ] Servicio registra inicio de sesión
- [ ] Servicio registra cierre de sesión
- [ ] Servicio obtiene historial del usuario
- [ ] ViewModel carga datos correctamente
- [ ] ViewModel ordena por fecha descendente
- [ ] Vista muestra lista de sesiones
- [ ] Vista muestra indicadores de color correctos
- [ ] Pull-to-refresh funciona
- [ ] Estado vacío se muestra correctamente
- [ ] Backend crea registro en MongoDB
- [ ] Backend actualiza registro al cerrar
- [ ] Backend retorna historial filtrado por usuario
- [ ] Índices de MongoDB funcionan
- [ ] Integración con AuthViewModel funciona

### Historia #2: Cambio de Contraseña

- [ ] Vista muestra formulario correctamente
- [ ] Card de requisitos es visible
- [ ] Validación de longitud funciona
- [ ] Validación de mayúscula funciona
- [ ] Validación de número funciona
- [ ] Validación de especial funciona
- [ ] Validación de confirmación funciona
- [ ] Toggle visibility funciona en los 3 campos
- [ ] AuthViewModel envía request correctamente
- [ ] Backend valida contraseña actual
- [ ] Backend valida formato de nueva contraseña
- [ ] Backend encripta con bcrypt
- [ ] Backend actualiza en MongoDB
- [ ] Diálogo de éxito se muestra
- [ ] Logout automático funciona
- [ ] Login con nueva contraseña funciona

**Total: 30 casos de prueba**

---

## 📸 Captura de Evidencias

Después de completar ambas historias:

1. Navegar a `docs/screenshots/`
2. Leer el README.md de esa carpeta
3. Tomar las 17 capturas especificadas
4. Nombrar exactamente como se indica
5. Verificar que cada captura muestre la funcionalidad clara

---

## 🚀 Deploy a Producción

### Railway (Backend)

1. Asegurarse que el código está en GitHub
2. Conectar Railway con el repositorio
3. Configurar variables de entorno:
   - `MONGODB_URI`
   - `JWT_SECRET`
   - `NODE_ENV=production`
4. Deploy automático con cada push

### MongoDB Atlas

1. Verificar que la nueva colección `historial_sesiones` existe
2. Verificar índices:
   ```javascript
   db.historial_sesiones.getIndexes()
   ```
3. Debe mostrar:
   - Index en `usuarioId` y `fechaHoraInicio`
   - Index en `sesionActiva`

---

## 📊 Métricas Finales

Al completar, verificar:

- ✅ **7 archivos nuevos creados**
- ✅ **3 archivos modificados**
- ✅ **~1,225 líneas de código**
- ✅ **4 endpoints API nuevos**
- ✅ **1 nueva colección MongoDB**
- ✅ **30 pruebas exitosas**
- ✅ **17 capturas de pantalla**
- ✅ **8 Story Points completados**

---

## 💡 Consejos Finales

1. **Tiempo Management:**
   - Historia #1: 2-3 días
   - Historia #2: 1 día
   - Total: 3-4 días de trabajo efectivo

2. **Prioridades:**
   - Empezar por Historia #2 (más simple, ganar confianza)
   - Luego Historia #1 (más compleja pero similar)

3. **Debugging:**
   - Usar `debugPrint()` extensivamente
   - Verificar MongoDB después de cada operación
   - Usar Postman para probar endpoints primero

4. **Documentación:**
   - Comentar código complejo
   - Actualizar README.md con tu nombre
   - Completar el checklist

5. **Git Commits:**
   - Commit después de cada paso completado
   - Mensajes descriptivos:
     - "feat: add historial sesion model"
     - "feat: implement change password UI"
     - "test: validate password requirements"

---

## 🔗 Referencias Útiles

- [Documentación Completa](Historia_Usuario_Examen_Unidad_II.md)
- [Arquitectura MVVM](lib/README_MVVM.md)
- [Flutter Provider](https://pub.dev/packages/provider)
- [MongoDB Mongoose](https://mongoosejs.com/)
- [bcrypt Node.js](https://www.npmjs.com/package/bcrypt)

---

**¡Éxito en el examen! 🎓**

