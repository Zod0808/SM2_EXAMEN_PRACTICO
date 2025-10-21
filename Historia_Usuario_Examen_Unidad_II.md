# Historia de Usuario para el Examen de la Unidad II de Móviles II

## Historia de Usuario

**Como** usuario autenticado (Guardia o Administrador),  
**quiero** ver un historial detallado de mis inicios de sesión,  
**para** monitorear la seguridad de mi cuenta y saber cuándo y desde qué dispositivo he accedido al sistema.

---

## Criterios de Aceptación

1. **Registro automático de sesión**
   - Al iniciar sesión exitosamente, se registra automáticamente:
     - Usuario (ID y nombre)
     - Rol del usuario (Guardia/Administrador)
     - Fecha y hora del inicio de sesión (timestamp UTC preciso)
     - Dirección IP desde donde se inició sesión
     - Información del dispositivo (user agent)
     - Estado de la sesión (activa/cerrada)

2. **Visualización del historial**
   - En la sección "Historial de inicios de sesión", el usuario puede ver una lista con:
     - Usuario y rol
     - Fecha y hora de inicio de sesión (formato legible)
     - Dirección IP
     - Dispositivo/plataforma
     - Indicador visual de sesión activa vs cerrada

3. **Ordenamiento y filtros**
   - Los registros se deben mostrar ordenados del más reciente al más antiguo
   - Opción de filtrar por rango de fechas
   - Búsqueda por dirección IP

4. **Interfaz responsive**
   - Lista clara y legible con scroll infinito o paginación
   - Pull-to-refresh para actualizar datos
   - Indicadores visuales de estado (activa/cerrada)

---

## Información del Proyecto

**Proyecto:** Sistema de Control de Accesos - Acees Group  
**Asignatura:** Móviles II  
**Evaluación:** Examen Unidad II  
**Arquitectura:** Flutter MVVM con Provider + Node.js Backend + MongoDB Atlas  
**Estado del Proyecto:** 38/38 User Stories completadas (100%)

---

## 🏗️ Arquitectura Técnica del Proyecto

### **Stack Tecnológico**
- **Frontend:** Flutter con patrón MVVM + Provider
- **Backend:** Node.js + Express.js
- **Base de Datos:** MongoDB Atlas
- **Autenticación:** JWT tokens con refresh automático
- **Estado:** Provider pattern para gestión de estado reactivo

### **Componentes Existentes a Extender**
- ✅ `auth_viewmodel.dart` - ViewModel de autenticación
- ✅ `login_view.dart` - Vista de inicio de sesión
- ✅ `session_service.dart` - Servicio de gestión de sesiones
- ✅ `usuario_model.dart` - Modelo de usuario con roles
- ✅ `api_service.dart` - Servicio de comunicación con backend

---

## 📋 Desglose Técnico Detallado

### **1. Modelo de Datos (Flutter)**

**Crear:** `lib/models/historial_sesion_model.dart`

```dart
class HistorialSesion {
  final String id;
  final String usuarioId;
  final String nombreUsuario;
  final String rol; // 'Guardia' o 'Administrador'
  final DateTime fechaHoraInicio;
  final DateTime? fechaHoraCierre;
  final String direccionIp;
  final String dispositivoInfo;
  final bool sesionActiva;

  HistorialSesion({
    required this.id,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.rol,
    required this.fechaHoraInicio,
    this.fechaHoraCierre,
    required this.direccionIp,
    required this.dispositivoInfo,
    this.sesionActiva = true,
  });

  factory HistorialSesion.fromJson(Map<String, dynamic> json) {
    return HistorialSesion(
      id: json['_id'],
      usuarioId: json['usuarioId'],
      nombreUsuario: json['nombreUsuario'],
      rol: json['rol'],
      fechaHoraInicio: DateTime.parse(json['fechaHoraInicio']),
      fechaHoraCierre: json['fechaHoraCierre'] != null 
          ? DateTime.parse(json['fechaHoraCierre']) 
          : null,
      direccionIp: json['direccionIp'],
      dispositivoInfo: json['dispositivoInfo'],
      sesionActiva: json['sesionActiva'] ?? false,
    );
  }
}
```

**Estimación:** 2 horas

---

### **2. Servicio de Historial de Sesiones (Flutter)**

**Crear:** `lib/services/historial_sesion_service.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/historial_sesion_model.dart';
import 'api_service.dart';

class HistorialSesionService {
  final ApiService _apiService;

  HistorialSesionService(this._apiService);

  // Registrar inicio de sesión
  Future<void> registrarInicioSesion({
    required String usuarioId,
    required String nombreUsuario,
    required String rol,
    required String direccionIp,
    required String dispositivoInfo,
  }) async {
    try {
      await _apiService.post('/historial-sesiones', {
        'usuarioId': usuarioId,
        'nombreUsuario': nombreUsuario,
        'rol': rol,
        'fechaHoraInicio': DateTime.now().toUtc().toIso8601String(),
        'direccionIp': direccionIp,
        'dispositivoInfo': dispositivoInfo,
        'sesionActiva': true,
      });
    } catch (e) {
      debugPrint('Error registrando inicio de sesión: $e');
      rethrow;
    }
  }

  // Registrar cierre de sesión
  Future<void> registrarCierreSesion(String sesionId) async {
    try {
      await _apiService.patch('/historial-sesiones/$sesionId/cerrar', {
        'fechaHoraCierre': DateTime.now().toUtc().toIso8601String(),
        'sesionActiva': false,
      });
    } catch (e) {
      debugPrint('Error registrando cierre de sesión: $e');
    }
  }

  // Obtener historial del usuario actual
  Future<List<HistorialSesion>> obtenerHistorialUsuario(String usuarioId) async {
    try {
      final response = await _apiService.get('/historial-sesiones/usuario/$usuarioId');
      final List<dynamic> data = response['historial'];
      return data.map((json) => HistorialSesion.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error obteniendo historial: $e');
      return [];
    }
  }
}
```

**Estimación:** 3 horas

---

### **3. Integración con AuthViewModel**

**Modificar:** `lib/viewmodels/auth_viewmodel.dart`

Agregar llamadas al servicio de historial en los métodos `login()` y `logout()`:

```dart
// En el método login(), después de autenticación exitosa:
await _historialSesionService.registrarInicioSesion(
  usuarioId: usuario.id,
  nombreUsuario: usuario.nombre,
  rol: usuario.rol,
  direccionIp: await _obtenerDireccionIP(),
  dispositivoInfo: await _obtenerInfoDispositivo(),
);

// En el método logout():
if (_sesionIdActual != null) {
  await _historialSesionService.registrarCierreSesion(_sesionIdActual!);
}
```

**Estimación:** 1.5 horas

---

### **4. Vista de Historial de Sesiones (Flutter)**

**Crear:** `lib/views/user/historial_sesiones_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/historial_sesion_viewmodel.dart';
import '../../models/historial_sesion_model.dart';

class HistorialSesionesView extends StatefulWidget {
  @override
  _HistorialSesionesViewState createState() => _HistorialSesionesViewState();
}

class _HistorialSesionesViewState extends State<HistorialSesionesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistorialSesionViewModel>().cargarHistorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Inicios de Sesión'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<HistorialSesionViewModel>().cargarHistorial(),
          ),
        ],
      ),
      body: Consumer<HistorialSesionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.historial.isEmpty) {
            return Center(
              child: Text('No hay registros de sesiones'),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.cargarHistorial,
            child: ListView.builder(
              itemCount: viewModel.historial.length,
              itemBuilder: (context, index) {
                final sesion = viewModel.historial[index];
                return _buildSesionCard(sesion);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSesionCard(HistorialSesion sesion) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: sesion.sesionActiva ? Colors.green : Colors.grey,
          child: Icon(
            sesion.sesionActiva ? Icons.circle : Icons.check_circle_outline,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${sesion.nombreUsuario} (${sesion.rol})',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('📅 ${_formatearFecha(sesion.fechaHoraInicio)}'),
            Text('🌐 IP: ${sesion.direccionIp}'),
            Text('📱 ${sesion.dispositivoInfo}'),
            if (sesion.fechaHoraCierre != null)
              Text('🔒 Cerrado: ${_formatearFecha(sesion.fechaHoraCierre!)}'),
          ],
        ),
        trailing: sesion.sesionActiva
            ? Chip(
                label: Text('Activa'),
                backgroundColor: Colors.green.shade100,
              )
            : Chip(
                label: Text('Cerrada'),
                backgroundColor: Colors.grey.shade300,
              ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
```

**Estimación:** 3 horas

---

### **5. ViewModel para Historial (Flutter)**

**Crear:** `lib/viewmodels/historial_sesion_viewmodel.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/historial_sesion_model.dart';
import '../services/historial_sesion_service.dart';
import '../services/session_service.dart';

class HistorialSesionViewModel extends ChangeNotifier {
  final HistorialSesionService _historialService;
  final SessionService _sessionService;

  List<HistorialSesion> _historial = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HistorialSesion> get historial => _historial;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HistorialSesionViewModel(this._historialService, this._sessionService);

  Future<void> cargarHistorial() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarioId = await _sessionService.getCurrentUserId();
      if (usuarioId != null) {
        _historial = await _historialService.obtenerHistorialUsuario(usuarioId);
        _historial.sort((a, b) => b.fechaHoraInicio.compareTo(a.fechaHoraInicio));
      }
    } catch (e) {
      _errorMessage = 'Error al cargar historial: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Estimación:** 2 horas

---

### **6. Backend - Schema MongoDB**

**Crear:** `backend/schemas/historialSesionSchema.js`

```javascript
const mongoose = require('mongoose');

const historialSesionSchema = new mongoose.Schema({
  usuarioId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Usuario',
    required: true,
    index: true
  },
  nombreUsuario: {
    type: String,
    required: true
  },
  rol: {
    type: String,
    enum: ['Guardia', 'Administrador'],
    required: true
  },
  fechaHoraInicio: {
    type: Date,
    required: true,
    default: Date.now,
    index: true
  },
  fechaHoraCierre: {
    type: Date,
    default: null
  },
  direccionIp: {
    type: String,
    required: true
  },
  dispositivoInfo: {
    type: String,
    required: true
  },
  sesionActiva: {
    type: Boolean,
    default: true,
    index: true
  }
}, {
  timestamps: true
});

// Índice compuesto para consultas eficientes
historialSesionSchema.index({ usuarioId: 1, fechaHoraInicio: -1 });

module.exports = mongoose.model('HistorialSesion', historialSesionSchema);
```

**Estimación:** 1 hora

---

### **7. Backend - Endpoints API**

**Crear:** `backend/routes/historialSesionRoutes.js`

```javascript
const express = require('express');
const router = express.Router();
const HistorialSesion = require('../schemas/historialSesionSchema');
const authMiddleware = require('../middleware/authMiddleware');

// Registrar inicio de sesión
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { usuarioId, nombreUsuario, rol, direccionIp, dispositivoInfo } = req.body;
    
    const nuevoHistorial = new HistorialSesion({
      usuarioId,
      nombreUsuario,
      rol,
      fechaHoraInicio: new Date(),
      direccionIp,
      dispositivoInfo,
      sesionActiva: true
    });

    await nuevoHistorial.save();
    res.status(201).json({ 
      success: true, 
      sesionId: nuevoHistorial._id,
      message: 'Inicio de sesión registrado' 
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Registrar cierre de sesión
router.patch('/:sesionId/cerrar', authMiddleware, async (req, res) => {
  try {
    const { sesionId } = req.params;
    
    await HistorialSesion.findByIdAndUpdate(sesionId, {
      fechaHoraCierre: new Date(),
      sesionActiva: false
    });

    res.json({ success: true, message: 'Cierre de sesión registrado' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Obtener historial de usuario
router.get('/usuario/:usuarioId', authMiddleware, async (req, res) => {
  try {
    const { usuarioId } = req.params;
    
    const historial = await HistorialSesion.find({ usuarioId })
      .sort({ fechaHoraInicio: -1 })
      .limit(50); // Últimas 50 sesiones

    res.json({ success: true, historial });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

module.exports = router;
```

**Estimación:** 2.5 horas

---

### **8. Integración y Pruebas**

**Tareas:**
1. Registrar el ViewModel en el Provider (main.dart)
2. Agregar ruta de navegación al historial desde el drawer/menú
3. Probar registro automático en login/logout
4. Validar ordenamiento correcto
5. Probar con múltiples sesiones
6. Verificar rendimiento con muchos registros
7. Probar funcionalidad offline (debe sincronizar después)

**Estimación:** 2 horas

---

## 🔗 Relación con User Stories Existentes

### **Extiende directamente:**
- ✅ **US001**: Autenticación de guardias - Añade auditoría al login
- ✅ **US002**: Manejo de roles - Registra el rol en cada sesión
- ✅ **US003**: Logout seguro - Registra cierre de sesión
- ✅ **US004**: Sesión configurable - Complementa con historial de sesiones

### **Utiliza patrones similares:**
- ✅ **US025**: Registrar decisión timestamp - Mismo patrón de timestamp UTC
- ✅ **US027**: Guardar fecha, hora, datos - Estructura similar de registro
- ✅ **US030**: Historial completo - Patrón de almacenamiento histórico

### **Se integra con:**
- ✅ `auth_viewmodel.dart` - Extiende funcionalidad de autenticación
- ✅ `session_service.dart` - Usa servicio de sesiones existente
- ✅ `usuario_model.dart` - Referencia al modelo de usuario
- ✅ MongoDB Atlas - Añade nueva colección al sistema existente

---

## 📊 Estimación Detallada

| Tarea | Tiempo Estimado |
|-------|-----------------|
| 1. Modelo de datos (Flutter) | 2h |
| 2. Servicio de historial | 3h |
| 3. Integración con AuthViewModel | 1.5h |
| 4. Vista de historial | 3h |
| 5. ViewModel para historial | 2h |
| 6. Schema MongoDB | 1h |
| 7. Endpoints API Backend | 2.5h |
| 8. Integración y pruebas | 2h |
| **TOTAL** | **17 horas** |

**Story Points:** 5  
**Prioridad:** Alta (Seguridad y auditoría)  
**Sprint sugerido:** Sprint 1 (junto con autenticación)

---

## ✅ Checklist de Implementación

### **Frontend (Flutter)**
- [ ] Crear `historial_sesion_model.dart`
- [ ] Crear `historial_sesion_service.dart`
- [ ] Crear `historial_sesion_viewmodel.dart`
- [ ] Crear `historial_sesiones_view.dart`
- [ ] Modificar `auth_viewmodel.dart` para integrar registro
- [ ] Registrar ViewModel en Provider (main.dart)
- [ ] Agregar ruta de navegación en menú de usuario
- [ ] Probar UI en diferentes tamaños de pantalla

### **Backend (Node.js)**
- [ ] Crear schema `historialSesionSchema.js`
- [ ] Crear rutas `historialSesionRoutes.js`
- [ ] Registrar rutas en `index.js`
- [ ] Probar endpoints con Postman/Insomnia
- [ ] Verificar índices de MongoDB para rendimiento

### **Pruebas**
- [ ] Login registra correctamente en historial
- [ ] Logout actualiza sesión como cerrada
- [ ] Historial se muestra ordenado (más reciente primero)
- [ ] Pull-to-refresh funciona correctamente
- [ ] Sesiones activas se distinguen visualmente
- [ ] Manejo de errores (sin conexión, timeout, etc.)

---

## 🎯 Contexto del Proyecto Acees Group

### **Estado Actual del Proyecto**
- ✅ 38/38 User Stories completadas (100%)
- ✅ Arquitectura Flutter MVVM completamente implementada
- ✅ Backend Node.js + Express con 20+ endpoints
- ✅ MongoDB Atlas con 7 colecciones activas
- ✅ Sistema de autenticación JWT robusto
- ✅ Funcionalidad offline completa

### **Esta User Story Añade:**
- 🆕 Nueva colección: `historial_sesiones`
- 🆕 3 nuevos archivos Flutter (model, service, view)
- 🆕 1 nuevo ViewModel
- 🆕 3 endpoints REST en backend
- 🆕 Auditoría completa de accesos al sistema

---

## 🔒 Consideraciones de Seguridad

1. **Privacidad de datos**
   - Solo el usuario puede ver su propio historial
   - Administradores pueden ver historial de todos (opcional)
   - Dirección IP se almacena de forma segura

2. **Validación de autenticación**
   - Todos los endpoints requieren token JWT válido
   - Validación de permisos por rol

3. **Retención de datos**
   - Definir política de retención (ej: 90 días)
   - Implementar limpieza automática de registros antiguos

4. **Alertas de seguridad (futura mejora)**
   - Notificar inicio desde IP no reconocida
   - Detectar múltiples sesiones simultáneas
   - Alertar por intentos de login fallidos

---

## 📱 Integración con Funcionalidad Offline

Dado que el proyecto tiene **funcionalidad offline completa** (US057), el historial de sesiones debe:

- Registrar inicio de sesión cuando haya conexión
- Si no hay conexión, encolar el registro para sincronización posterior
- Usar `offline_service.dart` existente para manejo de sincronización
- Cache local con SQLite para visualización offline

---

## 👥 Equipo del Proyecto

**Integrantes:**
- Cesar Fabián Chavez Linares
- Sebastián Arce Bracamonte
- Angel Gadiel Hernandéz Cruz

**Roles Sugeridos:**
- **Frontend Developer:** Implementación Flutter (models, services, views)
- **Backend Developer:** Endpoints y schema MongoDB
- **QA/Tester:** Pruebas exhaustivas e integración

---

## 📚 Referencias Técnicas

### **Archivos del Proyecto a Consultar:**
- `lib/viewmodels/auth_viewmodel.dart` - Implementación de autenticación
- `lib/services/session_service.dart` - Gestión de sesiones
- `lib/services/api_service.dart` - Comunicación con API
- `lib/models/usuario_model.dart` - Estructura de usuario
- `backend/index.js` - Servidor principal y rutas

### **Documentación:**
- Flutter Provider: https://pub.dev/packages/provider
- MongoDB Mongoose: https://mongoosejs.com/
- JWT Authentication: https://jwt.io/

---

**🎓 EVALUACIÓN: Examen Unidad II - Móviles II**  
**📅 Fecha de Creación:** 21 de Octubre de 2025  
**🏢 Proyecto:** Acees Group - Sistema de Control de Accesos

---

# 📚 Historias de Usuario Adicionales para el Examen

## Análisis de Implementación del Proyecto

### ✅ Funcionalidades YA IMPLEMENTADAS en el Proyecto

| US ID | Historia de Usuario | Archivos Implementados | Estado |
|-------|---------------------|------------------------|--------|
| **US001** | Autenticación de guardias | `auth_viewmodel.dart`, `login_view.dart`, `session_service.dart` | ✅ COMPLETO |
| **US002** | Manejo de roles | `usuario_model.dart` con roles Guardia/Administrador | ✅ COMPLETO |
| **US003** | Logout seguro | `session_service.dart` método `endSession()` | ✅ COMPLETO |
| **US004** | Sesión configurable | `session_config_view.dart`, `session_service.dart` (30 min configurable) | ✅ COMPLETO |
| **US008** | Asignar puntos de control | `punto_control_model.dart` | ✅ COMPLETO |
| **US009** | Modificar datos guardias | `historial_modificacion_model.dart` (auditoría completa) | ✅ COMPLETO |
| **US024** | Autorización manual | `decision_manual_model.dart` con autorizado/denegado + razón | ✅ COMPLETO |
| **US025** | Registrar decisión timestamp | `decision_manual_model.dart` con timestamp UTC | ✅ COMPLETO |
| **US028** | Distinguir entrada/salida | `presencia_model.dart`, campo `tipoAcceso` | ✅ COMPLETO |
| **US030** | Historial completo | `historial_view.dart` | ✅ COMPLETO |
| **US032** | Lista estudiantes en campus | `presencia_dashboard_view.dart` | ✅ COMPLETO |
| **US056** | Sincronización app-servidor | `sync_service.dart`, `sync_config_view.dart` | ✅ COMPLETO |
| **US057** | Funcionalidad offline | `offline_service.dart`, `offline_management_view.dart` | ✅ COMPLETO |
| **US059** | Múltiples guardias simultáneos | `session_guard_service.dart`, `session_management_view.dart` | ✅ COMPLETO |

---

## 🆕 Historias de Usuario PROPUESTAS para el Examen

### **Historia de Usuario #1: Historial de Inicios de Sesión**
**Estado:** 🆕 NUEVA (Implementar para el examen)  
**Complejidad:** Media  
**Story Points:** 5  
**Tiempo:** 17 horas

> *Esta es la historia principal del documento actual.*

---

### **Historia de Usuario #2: Cambio de Contraseña Personal**

**US ID:** US005  
**Sprint Original:** Sprint 1  
**Estado Actual:** 🔄 PARCIAL (backend existe, falta UI completa)

**Historia de Usuario:**

**Como** usuario del sistema (Guardia o Administrador),  
**quiero** cambiar mi contraseña de forma segura,  
**para** mantener mi cuenta protegida y actualizar credenciales periódicamente.

**Criterios de Aceptación:**

1. **Validación de contraseña actual**
   - El usuario debe ingresar su contraseña actual
   - Sistema valida que la contraseña actual sea correcta
   - Muestra error si la contraseña actual es incorrecta

2. **Nueva contraseña segura**
   - Nueva contraseña debe cumplir requisitos:
     - Mínimo 8 caracteres
     - Al menos una mayúscula
     - Al menos un número
     - Al menos un carácter especial
   - Confirmación de nueva contraseña (debe coincidir)

3. **Proceso de cambio**
   - Encriptación de la nueva contraseña antes de enviar
   - Actualización en base de datos
   - Cierre de sesión automático después del cambio
   - Mensaje de confirmación exitosa

4. **Seguridad**
   - Contraseña no se muestra en texto plano
   - Opción de "mostrar/ocultar" contraseña
   - Límite de intentos fallidos (5 intentos)

**Desglose Técnico:**

**Crear:** `lib/views/user/change_password_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordStrong(String password) {
    // Mínimo 8 caracteres
    if (password.length < 8) return false;
    
    // Al menos una mayúscula
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // Al menos un número
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // Al menos un carácter especial
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final success = await authViewModel.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Contraseña Actualizada'),
            ],
          ),
          content: Text(
            'Tu contraseña ha sido cambiada exitosamente. '
            'Por seguridad, debes iniciar sesión nuevamente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                authViewModel.logout(); // Cerrar sesión
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Error al cambiar contraseña'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Contraseña'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información de seguridad
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.security, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Requisitos de Seguridad',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('✓ Mínimo 8 caracteres'),
                          Text('✓ Al menos una mayúscula'),
                          Text('✓ Al menos un número'),
                          Text('✓ Al menos un carácter especial (!@#\$%^&*)'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Campo contraseña actual
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña Actual',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña actual';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Campo nueva contraseña
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su nueva contraseña';
                      }
                      if (!_isPasswordStrong(value)) {
                        return 'La contraseña no cumple los requisitos de seguridad';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Campo confirmar contraseña
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Nueva Contraseña',
                      prefixIcon: Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme su nueva contraseña';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),

                  // Botón de cambiar contraseña
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Cambiar Contraseña',
                      onPressed: authViewModel.isLoading ? null : _changePassword,
                      isLoading: authViewModel.isLoading,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

**Modificar:** `lib/viewmodels/auth_viewmodel.dart`

Agregar método:

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

**Backend:** `backend/routes/authRoutes.js`

```javascript
// Cambiar contraseña
router.post('/change-password', authMiddleware, async (req, res) => {
  try {
    const { userId, currentPassword, newPassword } = req.body;
    
    // Buscar usuario
    const usuario = await Usuario.findById(userId);
    if (!usuario) {
      return res.status(404).json({ success: false, message: 'Usuario no encontrado' });
    }

    // Verificar contraseña actual
    const isPasswordValid = await bcrypt.compare(currentPassword, usuario.password);
    if (!isPasswordValid) {
      return res.status(401).json({ success: false, message: 'Contraseña actual incorrecta' });
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

    res.json({ success: true, message: 'Contraseña actualizada exitosamente' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});
```

**Estimación:** 
- Frontend: 4 horas
- Backend: 2 horas
- Pruebas: 2 horas
- **Total: 8 horas**

**Story Points:** 3  
**Prioridad:** Media

---

### **Historia de Usuario #3: Búsqueda de Estudiantes**

**US ID:** US033  
**Sprint Original:** Sprint 3  
**Estado Actual:** 🔄 PARCIAL (backend tiene búsqueda, falta UI optimizada)

**Historia de Usuario:**

**Como** guardia o administrador,  
**quiero** buscar estudiantes por nombre, DNI o código,  
**para** encontrar rápidamente información específica de un estudiante.

**Criterios de Aceptación:**

1. **Barra de búsqueda**
   - Campo de búsqueda siempre visible en la parte superior
   - Placeholder: "Buscar por nombre, DNI o código..."
   - Icono de búsqueda visible

2. **Búsqueda en tiempo real**
   - Resultados se actualizan mientras el usuario escribe
   - Búsqueda a partir de 3 caracteres
   - Debounce de 500ms para optimizar

3. **Resultados mostrados**
   - Lista de estudiantes que coinciden
   - Muestra: foto, nombre completo, DNI, carrera
   - Estado (activo/inactivo) con indicador visual
   - Máximo 20 resultados iniciales

4. **Acciones sobre resultados**
   - Tap en un estudiante muestra detalles completos
   - Opción de ver historial de accesos
   - Estado de matricula vigente

**Desglose Técnico:**

**Crear:** `lib/views/admin/student_search_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../models/alumno_model.dart';
import 'dart:async';

class StudentSearchView extends StatefulWidget {
  @override
  _StudentSearchViewState createState() => _StudentSearchViewState();
}

class _StudentSearchViewState extends State<StudentSearchView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.length >= 3) {
        Provider.of<AdminViewModel>(context, listen: false)
            .searchStudents(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Estudiantes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, DNI o código...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Resultados de búsqueda
          Expanded(
            child: Consumer<AdminViewModel>(
              builder: (context, adminViewModel, child) {
                if (adminViewModel.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (_searchController.text.length < 3) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Ingresa al menos 3 caracteres para buscar',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final students = adminViewModel.searchResults;

                if (students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No se encontraron estudiantes',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return _buildStudentCard(student);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(AlumnoModel student) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: student.estado == 'activo' 
              ? Colors.green 
              : Colors.grey,
          child: Text(
            student.nombre[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          student.nombre,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DNI: ${student.dni}'),
            Text('Carrera: ${student.carrera ?? 'N/A'}'),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: student.estado == 'activo' 
                        ? Colors.green[100] 
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    student.estado.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: student.estado == 'activo' 
                          ? Colors.green[900] 
                          : Colors.red[900],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showStudentDetails(student);
        },
      ),
    );
  }

  void _showStudentDetails(AlumnoModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles del Estudiante'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Nombre:', student.nombre),
              _buildDetailRow('DNI:', student.dni),
              _buildDetailRow('Código:', student.codigo ?? 'N/A'),
              _buildDetailRow('Carrera:', student.carrera ?? 'N/A'),
              _buildDetailRow('Estado:', student.estado),
              _buildDetailRow('Matrícula:', 
                  student.matriculaVigente ? 'Vigente' : 'No vigente'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navegar a historial del estudiante
            },
            child: Text('Ver Historial'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
```

**Modificar:** `lib/viewmodels/admin_viewmodel.dart`

```dart
List<AlumnoModel> _searchResults = [];
List<AlumnoModel> get searchResults => _searchResults;

Future<void> searchStudents(String query) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await _apiService.get(
      '/estudiantes/buscar?q=${Uri.encodeComponent(query)}'
    );

    if (response['success']) {
      _searchResults = (response['estudiantes'] as List)
          .map((json) => AlumnoModel.fromJson(json))
          .toList();
    }
  } catch (e) {
    _errorMessage = 'Error al buscar estudiantes: ${e.toString()}';
    _searchResults = [];
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

**Backend:** `backend/routes/estudiantesRoutes.js`

```javascript
// Buscar estudiantes
router.get('/buscar', authMiddleware, async (req, res) => {
  try {
    const { q } = req.query;
    
    if (!q || q.length < 3) {
      return res.status(400).json({ 
        success: false, 
        message: 'La búsqueda debe tener al menos 3 caracteres' 
      });
    }

    // Búsqueda por nombre, DNI o código
    const estudiantes = await Estudiante.find({
      $or: [
        { nombre: { $regex: q, $options: 'i' } },
        { dni: { $regex: q, $options: 'i' } },
        { codigo: { $regex: q, $options: 'i' } }
      ]
    }).limit(20);

    res.json({ success: true, estudiantes });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});
```

**Estimación:**
- Frontend: 4 horas
- Backend: 1.5 horas
- Pruebas: 1.5 horas
- **Total: 7 horas**

**Story Points:** 3  
**Prioridad:** Media

---

### **Historia de Usuario #4: Lista de Estudiantes del Día**

**US ID:** US031  
**Sprint Original:** Sprint 3  
**Estado Actual:** 🔄 PARCIAL (función existe en backend, UI básica)

**Historia de Usuario:**

**Como** guardia o administrador,  
**quiero** ver una lista de todos los estudiantes que han ingresado hoy,  
**para** monitorear la actividad diaria del campus.

**Criterios de Aceptación:**

1. **Vista de lista diaria**
   - Muestra todos los estudiantes que ingresaron en el día actual
   - Lista ordenada por hora de ingreso (más reciente primero)
   - Contador total de estudiantes del día

2. **Información mostrada**
   - Nombre del estudiante
   - Hora de ingreso
   - Punto de control por donde ingresó
   - Estado actual (dentro/fuera del campus)

3. **Filtros**
   - Filtrar por punto de control
   - Filtrar por estado (solo dentro campus / todos)
   - Opción de ver solo entradas o entradas + salidas

4. **Actualización**
   - Botón de refrescar manual
   - Actualización automática cada 30 segundos
   - Pull-to-refresh

**Desglose Técnico:**

**Crear:** `lib/views/admin/daily_students_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../models/asistencia_model.dart';
import 'dart:async';

class DailyStudentsView extends StatefulWidget {
  @override
  _DailyStudentsViewState createState() => _DailyStudentsViewState();
}

class _DailyStudentsViewState extends State<DailyStudentsView> {
  Timer? _autoRefreshTimer;
  String _filterEstado = 'todos'; // 'todos', 'dentro', 'fuera'
  String? _filterPuntoControl;

  @override
  void initState() {
    super.initState();
    _loadDailyStudents();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _loadDailyStudents() {
    Provider.of<AdminViewModel>(context, listen: false).loadDailyStudents();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _loadDailyStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes de Hoy'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadDailyStudents,
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Consumer<AdminViewModel>(
        builder: (context, adminViewModel, child) {
          if (adminViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final students = _applyFilters(adminViewModel.dailyStudents);
          final totalCount = adminViewModel.dailyStudents.length;
          final dentroCount = adminViewModel.dailyStudents
              .where((s) => s.estadoActual == 'dentro')
              .length;

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              _loadDailyStudents();
            },
            child: Column(
              children: [
                // Estadísticas del día
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        '👥 Total Hoy',
                        totalCount.toString(),
                        Colors.blue,
                      ),
                      _buildStatCard(
                        '✅ Dentro',
                        dentroCount.toString(),
                        Colors.green,
                      ),
                      _buildStatCard(
                        '🚪 Salieron',
                        (totalCount - dentroCount).toString(),
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                // Filtros activos
                if (_filterEstado != 'todos' || _filterPuntoControl != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.yellow[100],
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt, size: 16),
                        SizedBox(width: 8),
                        Text('Filtros activos'),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filterEstado = 'todos';
                              _filterPuntoControl = null;
                            });
                          },
                          child: Text('Limpiar'),
                        ),
                      ],
                    ),
                  ),

                // Lista de estudiantes
                Expanded(
                  child: students.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No hay estudiantes hoy',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return _buildStudentCard(student);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(AsistenciaModel asistencia) {
    final isInside = asistencia.estadoActual == 'dentro';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isInside ? Colors.green : Colors.grey,
          child: Icon(
            isInside ? Icons.login : Icons.logout,
            color: Colors.white,
          ),
        ),
        title: Text(
          asistencia.estudianteNombre,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🕐 ${_formatHora(asistencia.horaIngreso)}'),
            Text('📍 ${asistencia.puntoControl}'),
            if (asistencia.horaSalida != null)
              Text('🚪 Salida: ${_formatHora(asistencia.horaSalida!)}'),
          ],
        ),
        trailing: Chip(
          label: Text(
            isInside ? 'DENTRO' : 'FUERA',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          backgroundColor: isInside ? Colors.green[100] : Colors.grey[300],
        ),
      ),
    );
  }

  String _formatHora(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  List<AsistenciaModel> _applyFilters(List<AsistenciaModel> students) {
    var filtered = students;

    if (_filterEstado != 'todos') {
      filtered = filtered
          .where((s) => s.estadoActual == _filterEstado)
          .toList();
    }

    if (_filterPuntoControl != null) {
      filtered = filtered
          .where((s) => s.puntoControl == _filterPuntoControl)
          .toList();
    }

    return filtered;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filtros'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Todos'),
              leading: Radio<String>(
                value: 'todos',
                groupValue: _filterEstado,
                onChanged: (value) {
                  setState(() => _filterEstado = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('Solo dentro del campus'),
              leading: Radio<String>(
                value: 'dentro',
                groupValue: _filterEstado,
                onChanged: (value) {
                  setState(() => _filterEstado = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('Solo fuera del campus'),
              leading: Radio<String>(
                value: 'fuera',
                groupValue: _filterEstado,
                onChanged: (value) {
                  setState(() => _filterEstado = value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Estimación:**
- Frontend: 5 horas
- Backend: 2 horas
- Pruebas: 2 horas
- **Total: 9 horas**

**Story Points:** 5  
**Prioridad:** Media

---

## 📊 Resumen de Historias de Usuario para el Examen

| # | Historia de Usuario | Estado | Story Points | Tiempo | Complejidad |
|---|---------------------|--------|--------------|--------|-------------|
| 1 | Historial de inicios de sesión | 🆕 NUEVA | 5 | 17h | Media |
| 2 | Cambio de contraseña personal | 🔄 PARCIAL | 3 | 8h | Baja-Media |
| 3 | Búsqueda de estudiantes | 🔄 PARCIAL | 3 | 7h | Baja-Media |
| 4 | Lista de estudiantes del día | 🔄 PARCIAL | 5 | 9h | Media |

**Total Story Points:** 16  
**Total Tiempo Estimado:** 41 horas

---

## 🎯 Recomendaciones para el Examen

### **Historia más Recomendada para el Examen:**

**🏆 Historia #1: Historial de Inicios de Sesión**

**Razones:**
1. ✅ Es completamente nueva (no está implementada)
2. ✅ Usa patrones existentes del proyecto (US025, US027)
3. ✅ Integración clara con componentes existentes
4. ✅ Documentación completa con código de ejemplo
5. ✅ Demuestra conocimientos de: Models, Services, ViewModels, Views, Backend
6. ✅ Funcionalidad relevante para seguridad y auditoría

### **Alternativas Buenas:**

**🥈 Historia #2: Cambio de Contraseña**
- Más sencilla de implementar (8 horas vs 17 horas)
- UI menos compleja
- Backend straightforward

**🥉 Historia #3: Búsqueda de Estudiantes**
- Funcionalidad práctica y útil
- Introduce conceptos de debouncing y búsqueda en tiempo real
- UI interactiva

---

## 🔧 Archivos del Proyecto a Extender

### **Modelos Existentes que puedes usar:**
- `alumno_model.dart` - Estudiantes
- `usuario_model.dart` - Usuarios/guardias
- `asistencia_model.dart` - Registros de asistencia
- `decision_manual_model.dart` - Decisiones manuales con timestamp
- `historial_modificacion_model.dart` - Auditoría de cambios

### **Servicios Existentes:**
- `api_service.dart` - Comunicación con backend
- `session_service.dart` - Gestión de sesiones (US004 implementado)
- `auth_service.dart` - Autenticación
- `offline_service.dart` - Funcionalidad offline
- `sync_service.dart` - Sincronización

### **ViewModels Existentes:**
- `auth_viewmodel.dart` - Extender para cambio de contraseña o historial
- `admin_viewmodel.dart` - Extender para búsqueda y listas
- `nfc_viewmodel.dart` - Lectura NFC
- `reports_viewmodel.dart` - Reportes

---

