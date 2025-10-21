# 📱 Examen Práctico - Unidad II - Móviles II

## 📋 Información del Examen

| Campo | Información |
|-------|-------------|
| **Curso** | Sistemas Móviles II |
| **Alumno** | Cesar Fabian Chávez Linares |
| **Fecha** | 21 de Octubre de 2025 |
| **Repositorio** | [https://github.com/Zod0808/SM2_EXAMEN_PRACTICO.git](https://github.com/Zod0808/SM2_EXAMEN_PRACTICO.git) |
| **Proyecto Base** | Access Group - Sistema de Control de Acceso NFC |
| **Arquitectura** | Flutter MVVM + Node.js + MongoDB Atlas |

---

## 🎯 Descripción del Proyecto

**Acees Group** es un sistema completo de control de acceso universitario que utiliza tecnología NFC para registrar y gestionar el ingreso y salida de estudiantes al campus. El sistema cuenta con una aplicación móvil Flutter con arquitectura MVVM, backend en Node.js con Express, y base de datos MongoDB Atlas.

### **Estado del Proyecto Base**
- ✅ **38/38 User Stories completadas** (100% del backlog original)
- ✅ Arquitectura MVVM completamente implementada
- ✅ Backend desplegado en producción (Railway)
- ✅ Base de datos MongoDB Atlas con 7 colecciones
- ✅ Sistema de autenticación JWT con roles
- ✅ Funcionalidad offline completa con sincronización

---

## 📚 Historias de Usuario Implementadas para el Examen

Para este examen práctico se implementaron **2 nuevas historias de usuario** que extienden la funcionalidad del sistema base:

---

### 🔐 Historia de Usuario #1: Historial de Inicios de Sesión

**Como** usuario autenticado (Guardia o Administrador),  
**quiero** ver un historial detallado de mis inicios de sesión,  
**para** monitorear la seguridad de mi cuenta y saber cuándo y desde qué dispositivo he accedido al sistema.

#### **Criterios de Aceptación Implementados**

✅ **Registro automático de sesión**
- Al iniciar sesión exitosamente, se registra automáticamente:
  - Usuario (ID y nombre)
  - Rol del usuario (Guardia/Administrador)
  - Fecha y hora del inicio de sesión (timestamp UTC preciso)
  - Dirección IP desde donde se inició sesión
  - Información del dispositivo (user agent)
  - Estado de la sesión (activa/cerrada)

✅ **Visualización del historial**
- Sección "Historial de inicios de sesión" accesible desde el menú principal
- Lista con:
  - Usuario y rol
  - Fecha y hora de inicio de sesión (formato legible)
  - Dirección IP
  - Dispositivo/plataforma
  - Indicador visual de sesión activa vs cerrada

✅ **Ordenamiento**
- Los registros se muestran ordenados del más reciente al más antiguo
- Pull-to-refresh para actualizar datos
- Indicadores visuales de estado

#### **Funcionalidades Técnicas Implementadas**

1. **Modelo de Datos** - `lib/models/historial_sesion_model.dart`
   - Modelo completo con campos: id, usuarioId, nombreUsuario, rol, fechaHoraInicio, fechaHoraCierre, direccionIp, dispositivoInfo, sesionActiva
   - Métodos `fromJson()` y `toJson()` para serialización
   - Getters para formato de fecha legible

2. **Servicio** - `lib/services/historial_sesion_service.dart`
   - `registrarInicioSesion()`: Registra automáticamente al hacer login
   - `registrarCierreSesion()`: Actualiza el registro al hacer logout
   - `obtenerHistorialUsuario()`: Obtiene historial completo del usuario actual

3. **ViewModel** - `lib/viewmodels/historial_sesion_viewmodel.dart`
   - Gestión de estado con Provider
   - Método `cargarHistorial()` con manejo de errores
   - Ordenamiento automático por fecha descendente

4. **Vista** - `lib/views/user/historial_sesiones_view.dart`
   - AppBar con botón de refresh
   - Lista con cards visuales por cada sesión
   - Indicadores de color (verde=activa, gris=cerrada)
   - Pull-to-refresh implementado
   - Estado vacío con mensaje informativo

5. **Backend** - `backend/routes/historialSesionRoutes.js`
   - Schema MongoDB con índices optimizados
   - Endpoints REST:
     - `POST /historial-sesiones` - Registrar inicio de sesión
     - `PATCH /historial-sesiones/:id/cerrar` - Registrar cierre
     - `GET /historial-sesiones/usuario/:id` - Obtener historial
   - Middleware de autenticación JWT

6. **Integración con Sistema Existente**
   - Modificación de `auth_viewmodel.dart` para registrar automáticamente
   - Integración con `session_service.dart` existente
   - Captura de IP y user agent del dispositivo

#### **Complejidad y Estimación**

- **Story Points**: 5
- **Tiempo Estimado**: 17 horas
- **Complejidad**: Media
- **Prioridad**: Alta (Seguridad y auditoría)

---

### 🔑 Historia de Usuario #2: Cambio de Contraseña Personal

**Como** usuario del sistema (Guardia o Administrador),  
**quiero** cambiar mi contraseña de forma segura,  
**para** mantener mi cuenta protegida y actualizar credenciales periódicamente.

#### **Criterios de Aceptación Implementados**

✅ **Validación de contraseña actual**
- El usuario debe ingresar su contraseña actual
- Sistema valida que la contraseña actual sea correcta
- Muestra error descriptivo si la contraseña actual es incorrecta

✅ **Nueva contraseña segura**
- Validación de requisitos de seguridad:
  - ✓ Mínimo 8 caracteres
  - ✓ Al menos una mayúscula
  - ✓ Al menos un número
  - ✓ Al menos un carácter especial
- Confirmación de nueva contraseña (debe coincidir)
- Validación en tiempo real con feedback visual

✅ **Proceso de cambio**
- Encriptación de la nueva contraseña antes de enviar
- Actualización en base de datos con bcrypt
- Cierre de sesión automático después del cambio exitoso
- Mensaje de confirmación con diálogo modal

✅ **Seguridad**
- Contraseña no se muestra en texto plano
- Botones "mostrar/ocultar" contraseña en cada campo
- Validación tanto en frontend como backend

#### **Funcionalidades Técnicas Implementadas**

1. **Vista** - `lib/views/user/change_password_view.dart`
   - Formulario con 3 campos:
     - Contraseña actual
     - Nueva contraseña
     - Confirmar nueva contraseña
   - Toggle visibility para cada campo
   - Card informativo con requisitos de seguridad
   - Validación en tiempo real con `_isPasswordStrong()`
   - Botón de acción con estado de loading
   - Diálogo de confirmación post-cambio

2. **Integración con AuthViewModel** - `lib/viewmodels/auth_viewmodel.dart`
   - Nuevo método `changePassword()`:
     - Valida contraseña actual
     - Envía nueva contraseña al backend
     - Manejo de errores con mensajes descriptivos
     - Actualiza estado de loading

3. **Backend** - `backend/routes/authRoutes.js`
   - Endpoint `POST /auth/change-password`:
     - Verifica identidad del usuario (JWT)
     - Compara contraseña actual con bcrypt
     - Valida formato de nueva contraseña
     - Encripta nueva contraseña con bcrypt (salt rounds: 10)
     - Actualiza en MongoDB
     - Retorna respuesta de éxito/error

4. **Validaciones de Seguridad**
   - Frontend:
     - Regex para mayúsculas: `/[A-Z]/`
     - Regex para números: `/[0-9]/`
     - Regex para especiales: `/[!@#$%^&*(),.?":{}|<>]/`
     - Longitud mínima: 8 caracteres
   - Backend:
     - Validación de contraseña actual
     - Validación de longitud
     - Encriptación segura con bcrypt

5. **Flujo de Usuario**
   1. Usuario accede desde menú de perfil
   2. Ingresa contraseña actual
   3. Ingresa nueva contraseña (con validación en tiempo real)
   4. Confirma nueva contraseña
   5. Sistema valida y actualiza
   6. Muestra diálogo de confirmación
   7. Cierra sesión automáticamente
   8. Usuario debe iniciar sesión con nueva contraseña

#### **Complejidad y Estimación**

- **Story Points**: 3
- **Tiempo Estimado**: 8 horas
- **Complejidad**: Baja-Media
- **Prioridad**: Media

---

## 🏗️ Arquitectura Técnica

### **Stack Tecnológico**

```
📁 Arquitectura MVVM
├── 📱 Frontend (Flutter)
│   ├── Models (Modelos de datos)
│   ├── Services (Lógica de negocio)
│   ├── ViewModels (Estado y controladores)
│   └── Views (Interfaz de usuario)
├── 🌐 Backend (Node.js + Express)
│   ├── Routes (Endpoints REST)
│   ├── Schemas (Modelos MongoDB)
│   └── Middleware (Autenticación)
└── 💾 Base de Datos (MongoDB Atlas)
    └── Colecciones optimizadas con índices
```

### **Tecnologías Utilizadas**

| Capa | Tecnología | Propósito |
|------|------------|-----------|
| **Frontend** | Flutter 3.x | Framework multiplataforma |
| **Estado** | Provider | Gestión de estado reactivo |
| **Patrones** | MVVM | Arquitectura escalable |
| **HTTP** | http package | Comunicación con API |
| **Backend** | Node.js + Express | API REST |
| **Base de Datos** | MongoDB Atlas | NoSQL en la nube |
| **Autenticación** | JWT + bcrypt | Seguridad |
| **Despliegue** | Railway | Hosting backend |

---

## 📱 Capturas de Pantalla - Evidencias de Implementación

### Historia #1: Historial de Inicios de Sesión

#### 1. Pantalla de Login (Registro Automático)
![Login Screen](docs/screenshots/01_login_screen.png)
> Al iniciar sesión, el sistema automáticamente registra el acceso con timestamp, IP y dispositivo.

#### 2. Menú Principal con Opción de Historial
![Main Menu](docs/screenshots/02_main_menu_historial.png)
> Nueva opción "Historial de Sesiones" agregada al drawer/menú principal.

#### 3. Vista de Historial de Sesiones - Lista Completa
![Historial List](docs/screenshots/03_historial_list.png)
> Lista ordenada de todas las sesiones del usuario con indicadores visuales:
> - 🟢 Verde: Sesión activa
> - ⚪ Gris: Sesión cerrada
> - Información: Fecha, hora, IP, dispositivo

#### 4. Detalle de Sesión Activa
![Session Active](docs/screenshots/04_session_active_detail.png)
> Sesión activa mostrada con:
> - Usuario y rol
> - Fecha y hora de inicio
> - Dirección IP
> - Información del dispositivo
> - Chip verde "ACTIVA"

#### 5. Historial con Múltiples Sesiones
![Multiple Sessions](docs/screenshots/05_multiple_sessions.png)
> Vista del historial con múltiples sesiones, ordenadas de más reciente a más antigua.

#### 6. Pull to Refresh
![Pull Refresh](docs/screenshots/06_pull_refresh.png)
> Funcionalidad de pull-to-refresh para actualizar el historial en tiempo real.

#### 7. Estado Vacío
![Empty State](docs/screenshots/07_empty_state.png)
> Estado vacío cuando no hay registros de sesiones anteriores.

---

### Historia #2: Cambio de Contraseña Personal

#### 8. Acceso al Cambio de Contraseña
![Access Change Password](docs/screenshots/08_access_change_password.png)
> Opción "Cambiar Contraseña" accesible desde el menú de perfil/configuración.

#### 9. Formulario de Cambio de Contraseña
![Change Password Form](docs/screenshots/09_change_password_form.png)
> Formulario completo con:
> - Card informativo con requisitos de seguridad
> - Campo de contraseña actual
> - Campo de nueva contraseña
> - Campo de confirmación
> - Botones de mostrar/ocultar para cada campo

#### 10. Requisitos de Seguridad
![Security Requirements](docs/screenshots/10_security_requirements.png)
> Card informativo destacado mostrando:
> - ✓ Mínimo 8 caracteres
> - ✓ Al menos una mayúscula
> - ✓ Al menos un número
> - ✓ Al menos un carácter especial

#### 11. Validación de Contraseña Débil
![Weak Password](docs/screenshots/11_weak_password_validation.png)
> Mensaje de error cuando la contraseña no cumple requisitos de seguridad.

#### 12. Contraseñas No Coinciden
![Password Mismatch](docs/screenshots/12_password_mismatch.png)
> Error mostrado cuando la confirmación no coincide con la nueva contraseña.

#### 13. Contraseña Actual Incorrecta
![Wrong Current Password](docs/screenshots/13_wrong_current_password.png)
> SnackBar de error cuando la contraseña actual es incorrecta.

#### 14. Toggle Mostrar/Ocultar Contraseña
![Toggle Visibility](docs/screenshots/14_toggle_visibility.png)
> Botones de ojo para mostrar u ocultar cada campo de contraseña.

#### 15. Proceso de Loading
![Loading State](docs/screenshots/15_loading_state.png)
> Botón con indicador de carga mientras se procesa el cambio.

#### 16. Diálogo de Confirmación Exitosa
![Success Dialog](docs/screenshots/16_success_dialog.png)
> Diálogo modal confirmando el cambio exitoso:
> - ✅ Icono de éxito
> - Mensaje de confirmación
> - Información sobre cierre de sesión automático

#### 17. Cierre de Sesión Automático
![Auto Logout](docs/screenshots/17_auto_logout.png)
> Sistema redirige automáticamente al login después del cambio exitoso.

---

## 🔧 Archivos Creados/Modificados para el Examen

### **Archivos Nuevos Creados**

1. **Modelos**
   - `lib/models/historial_sesion_model.dart` *(225 líneas)*

2. **Servicios**
   - `lib/services/historial_sesion_service.dart` *(90 líneas)*

3. **ViewModels**
   - `lib/viewmodels/historial_sesion_viewmodel.dart` *(75 líneas)*

4. **Vistas**
   - `lib/views/user/historial_sesiones_view.dart` *(320 líneas)*
   - `lib/views/user/change_password_view.dart` *(280 líneas)*

5. **Backend - Schemas**
   - `backend/schemas/historialSesionSchema.js` *(45 líneas)*

6. **Backend - Routes**
   - `backend/routes/historialSesionRoutes.js` *(80 líneas)*
   - Extensión en `backend/routes/authRoutes.js` *(40 líneas nuevas)*

### **Archivos Modificados**

1. **ViewModels**
   - `lib/viewmodels/auth_viewmodel.dart`
     - Agregado método `changePassword()` *(35 líneas)*
     - Integración con `historial_sesion_service` *(15 líneas)*

2. **Main**
   - `lib/main.dart`
     - Registro de `HistorialSesionViewModel` en Provider *(5 líneas)*
     - Rutas de navegación para nuevas vistas *(10 líneas)*

3. **Backend**
   - `backend/index.js`
     - Importación y registro de nuevas rutas *(5 líneas)*

**Total de Líneas de Código: ~1,225 líneas**

---

## 📊 Base de Datos - Nueva Colección

### **Colección: `historial_sesiones`**

```javascript
{
  "_id": ObjectId,
  "usuarioId": ObjectId (ref: usuarios),
  "nombreUsuario": String,
  "rol": String (enum: ['Guardia', 'Administrador']),
  "fechaHoraInicio": Date (indexed),
  "fechaHoraCierre": Date | null,
  "direccionIp": String,
  "dispositivoInfo": String,
  "sesionActiva": Boolean (indexed),
  "createdAt": Date,
  "updatedAt": Date
}

// Índices:
// 1. { usuarioId: 1, fechaHoraInicio: -1 } - Para consultas por usuario
// 2. { sesionActiva: 1 } - Para filtrar sesiones activas
// 3. { fechaHoraInicio: 1 } - Para ordenamiento temporal
```

---

## 📡 Nuevos Endpoints API

### **Historial de Sesiones**

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `POST` | `/historial-sesiones` | Registrar inicio de sesión | JWT |
| `PATCH` | `/historial-sesiones/:id/cerrar` | Registrar cierre de sesión | JWT |
| `GET` | `/historial-sesiones/usuario/:id` | Obtener historial del usuario | JWT |

### **Cambio de Contraseña**

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `POST` | `/auth/change-password` | Cambiar contraseña del usuario | JWT |

### **Ejemplos de Request/Response**

#### Registrar Inicio de Sesión
```javascript
// Request
POST /historial-sesiones
Authorization: Bearer <token>
{
  "usuarioId": "67123abc...",
  "nombreUsuario": "Juan Pérez",
  "rol": "Guardia",
  "direccionIp": "192.168.1.100",
  "dispositivoInfo": "Android 13 - Pixel 6"
}

// Response
{
  "success": true,
  "sesionId": "67234def...",
  "message": "Inicio de sesión registrado"
}
```

#### Cambiar Contraseña
```javascript
// Request
POST /auth/change-password
Authorization: Bearer <token>
{
  "userId": "67123abc...",
  "currentPassword": "OldPass123!",
  "newPassword": "NewPass456@"
}

// Response
{
  "success": true,
  "message": "Contraseña actualizada exitosamente"
}
```

---

## 🚀 Instrucciones de Ejecución

### **Prerrequisitos**

- Flutter SDK 3.x o superior
- Node.js 18.x o superior
- MongoDB Atlas (cuenta configurada)
- Git

### **Clonar el Repositorio**

```bash
git clone https://github.com/Zod0808/SM2_EXAMEN_PRACTICO.git
cd SM2_EXAMEN_PRACTICO
```

### **Configurar Backend**

```bash
# Navegar a carpeta backend
cd backend

# Instalar dependencias
npm install

# Configurar variables de entorno
# Crear archivo .env con:
MONGODB_URI=mongodb+srv://usuario:password@cluster.mongodb.net/acees_group
JWT_SECRET=tu_secreto_aqui
NODE_ENV=development
PORT=3000

# Iniciar servidor
npm start
```

### **Configurar Flutter App**

```bash
# En otra terminal, desde la raíz del proyecto

# Instalar dependencias
flutter pub get

# Configurar URL del backend
# Editar: lib/config/api_config.dart
# Cambiar baseUrl según tu configuración

# Ejecutar app
flutter run
```

### **Probar las Nuevas Funcionalidades**

1. **Historial de Sesiones:**
   - Iniciar sesión con cualquier usuario
   - Navegar a "Historial de Sesiones" desde el menú
   - Verificar que aparece el registro del inicio de sesión actual
   - Cerrar sesión y volver a entrar para ver múltiples registros

2. **Cambio de Contraseña:**
   - Navegar a perfil/configuración
   - Seleccionar "Cambiar Contraseña"
   - Ingresar contraseña actual
   - Ingresar nueva contraseña (cumpliendo requisitos)
   - Confirmar cambio
   - Verificar cierre de sesión automático
   - Iniciar sesión con nueva contraseña

---

## 🧪 Pruebas Realizadas

### **Historia #1: Historial de Sesiones**

| Caso de Prueba | Resultado | Estado |
|----------------|-----------|--------|
| Registro automático al login | ✅ Se registra correctamente | PASS |
| Visualización de historial | ✅ Lista se muestra ordenada | PASS |
| Indicador de sesión activa | ✅ Color verde para activa | PASS |
| Registro de cierre al logout | ✅ Se actualiza correctamente | PASS |
| Pull-to-refresh | ✅ Actualiza datos | PASS |
| Estado vacío | ✅ Mensaje informativo mostrado | PASS |
| Ordenamiento descendente | ✅ Más reciente primero | PASS |
| Captura de IP | ✅ IP registrada correctamente | PASS |
| Info de dispositivo | ✅ User agent capturado | PASS |

### **Historia #2: Cambio de Contraseña**

| Caso de Prueba | Resultado | Estado |
|----------------|-----------|--------|
| Validación contraseña corta | ✅ Error mostrado | PASS |
| Validación sin mayúscula | ✅ Error mostrado | PASS |
| Validación sin número | ✅ Error mostrado | PASS |
| Validación sin carácter especial | ✅ Error mostrado | PASS |
| Confirmación no coincide | ✅ Error de coincidencia | PASS |
| Contraseña actual incorrecta | ✅ Error de autenticación | PASS |
| Cambio exitoso | ✅ Confirmación y logout | PASS |
| Toggle mostrar/ocultar | ✅ Funciona en los 3 campos | PASS |
| Loading state | ✅ Indicador visible | PASS |
| Encriptación bcrypt | ✅ Password hasheado en BD | PASS |

**Total Casos de Prueba: 19**  
**Casos Exitosos: 19**  
**Porcentaje de Éxito: 100%**

---

## 📈 Métricas del Examen

### **Complejidad del Código**

| Métrica | Valor |
|---------|-------|
| Archivos creados | 7 |
| Archivos modificados | 3 |
| Líneas de código escritas | ~1,225 |
| Modelos implementados | 1 |
| Servicios implementados | 1 |
| ViewModels implementados | 1 |
| Vistas implementadas | 2 |
| Endpoints API creados | 4 |
| Pruebas exitosas | 19/19 |

### **Story Points Completados**

- Historia #1: 5 puntos
- Historia #2: 3 puntos
- **Total: 8 Story Points**

### **Tiempo de Implementación**

- Historia #1: 1 hora (estimado)
- Historia #2: 1 hora (estimado)
- **Total: 2 horas**

---

## 🔗 Enlaces Importantes

- **Repositorio GitHub**: [https://github.com/Zod0808/SM2_EXAMEN_PRACTICO.git](https://github.com/Zod0808/SM2_EXAMEN_PRACTICO.git)
- **Documentación Completa**: [Historia_Usuario_Examen_Unidad_II.md](Historia_Usuario_Examen_Unidad_II.md)
- **Reporte User Stories**: [REPORTE_COMPLETO_USER_STORIES.md](REPORTE_COMPLETO_USER_STORIES.md)
- **Arquitectura MVVM**: [lib/README_MVVM.md](lib/README_MVVM.md)

---

## 👥 Equipo de Desarrollo

**Integrantes del Proyecto Acees Group:**
- Cesar Fabián Chavez Linares
- Sebastián Arce Bracamonte
- Angel Gadiel Hernandéz Cruz
- Juan Brendon Luna Juarez

**Implementación del Examen:**
- Cesar Fabián Chavez Linares

---

## 📝 Conclusiones

### **Logros Alcanzados**

1. ✅ **Implementación Exitosa de 2 Historias de Usuario**
   - Historial de Inicios de Sesión (5 SP)
   - Cambio de Contraseña Personal (3 SP)

2. ✅ **Integración Perfecta con Sistema Existente**
   - Uso de arquitectura MVVM del proyecto base
   - Integración con servicios existentes
   - Reutilización de componentes UI

3. ✅ **Código de Calidad**
   - Validaciones tanto en frontend como backend
   - Manejo de errores robusto
   - Encriptación segura de contraseñas
   - Auditoría completa de sesiones

4. ✅ **Funcionalidades de Producción**
   - Pull-to-refresh
   - Loading states
   - Estados vacíos
   - Feedback visual inmediato
   - Responsive design

### **Aprendizajes Obtenidos**

1. **Arquitectura MVVM en Flutter**
   - Separación clara de responsabilidades
   - Gestión de estado con Provider
   - Patrón ViewModel escalable

2. **Seguridad en Aplicaciones Móviles**
   - Encriptación con bcrypt
   - Validación de contraseñas robustas
   - Auditoría de accesos

3. **Integración Frontend-Backend**
   - API REST con Node.js + Express
   - Autenticación JWT
   - Manejo de errores HTTP

4. **Base de Datos NoSQL**
   - Diseño de schemas MongoDB
   - Índices para optimización
   - Referencias entre colecciones

### **Mejoras Futuras Sugeridas**

1. 🔮 **Alertas de Seguridad**
   - Notificar inicio desde IP no reconocida
   - Detectar múltiples sesiones simultáneas
   - Alertar por intentos de login fallidos

2. 🔮 **Políticas de Contraseña**
   - Expiración automática de contraseñas
   - Historial de contraseñas previas
   - Recordatorios de cambio periódico

3. 🔮 **Analytics del Historial**
   - Gráficos de accesos por día/hora
   - Mapa de IPs de acceso
   - Exportación de historial a PDF

---

## 📄 Licencia

Este proyecto es parte del curso de Sistemas Móviles II y fue desarrollado con fines educativos.

---

## 📞 Contacto

Para consultas sobre este examen:
- **Email**: [fabiach_2013@hotmail.com]
- **GitHub**: [https://github.com/Zod0808](https://github.com/Zod0808)

---

**🎓 Examen Unidad II - Sistemas Móviles II**  
**📅 Fecha: 21 de Octubre de 2025**  
**🏢 Proyecto: Acees Group - Control de Acceso NFC**  
**✨ Historias Implementadas: 2/2 (100%)**
