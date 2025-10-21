# 📸 Capturas de Pantalla - Evidencias del Examen

Esta carpeta contiene las capturas de pantalla que demuestran la implementación de las historias de usuario del examen.

## 📋 Lista de Capturas Requeridas

### Historia #1: Historial de Inicios de Sesión

1. **01_login_screen.png**
   - Pantalla de login del sistema
   - Muestra formulario de usuario y contraseña
   - Evidencia del punto donde se registra automáticamente la sesión

2. **02_main_menu_historial.png**
   - Menú principal (drawer) con la opción "Historial de Sesiones"
   - Destacar la nueva opción agregada

3. **03_historial_list.png**
   - Vista principal del historial de sesiones
   - Lista con múltiples registros
   - Mostrar indicadores de sesión activa (verde) y cerrada (gris)

4. **04_session_active_detail.png**
   - Detalle de una sesión activa
   - Incluye: nombre, rol, fecha/hora, IP, dispositivo
   - Chip verde con texto "ACTIVA"

5. **05_multiple_sessions.png**
   - Vista con 4-5 sesiones en el historial
   - Ordenadas de más reciente a antigua
   - Mezcla de sesiones activas y cerradas

6. **06_pull_refresh.png**
   - Acción de pull-to-refresh en acción
   - Mostrar indicador de carga circular

7. **07_empty_state.png**
   - Estado cuando no hay registros
   - Icono de calendario con mensaje "No hay registros de sesiones"

### Historia #2: Cambio de Contraseña Personal

8. **08_access_change_password.png**
   - Menú de perfil/configuración
   - Opción "Cambiar Contraseña" destacada

9. **09_change_password_form.png**
   - Formulario completo de cambio de contraseña
   - Card azul con requisitos de seguridad
   - Tres campos de contraseña visibles

10. **10_security_requirements.png**
    - Close-up del card de requisitos de seguridad
    - Mostrar claramente los 4 requisitos con checkmarks

11. **11_weak_password_validation.png**
    - Error de validación cuando contraseña no cumple requisitos
    - Mensaje en rojo debajo del campo

12. **12_password_mismatch.png**
    - Error cuando confirmación no coincide con nueva contraseña
    - Mensaje: "Las contraseñas no coinciden"

13. **13_wrong_current_password.png**
    - SnackBar rojo mostrando error de contraseña actual incorrecta
    - Mensaje: "Contraseña actual incorrecta"

14. **14_toggle_visibility.png**
    - Mostrar los botones de ojo para mostrar/ocultar contraseña
    - Al menos uno con contraseña visible

15. **15_loading_state.png**
    - Botón "Cambiar Contraseña" en estado de loading
    - Circular progress indicator en el botón

16. **16_success_dialog.png**
    - Diálogo modal de éxito
    - Icono verde de check
    - Título: "Contraseña Actualizada"
    - Mensaje de confirmación

17. **17_auto_logout.png**
    - Pantalla de login después del logout automático
    - Opcional: mostrar algún mensaje de "Sesión cerrada"

## 🎯 Cómo Tomar las Capturas

### **Preparación**

1. Ejecutar el backend:
   ```bash
   cd backend
   npm start
   ```

2. Ejecutar la app Flutter:
   ```bash
   flutter run
   ```

3. Usar un dispositivo o emulador con buena resolución (mínimo 1080x1920)

### **Tomar Capturas en Diferentes Plataformas**

#### Android (Emulador)
- Usar el botón de captura del emulador
- O presionar `Ctrl + S` (Windows/Linux) o `Cmd + S` (Mac)
- Las capturas se guardan en: `~/Pictures/Screenshots/`

#### iOS (Simulador)
- Presionar `Cmd + S`
- Las capturas se guardan en el escritorio

#### Dispositivo Real Android
- Presionar `Power + Volume Down` simultáneamente

#### Dispositivo Real iOS
- iPhone con Face ID: `Side Button + Volume Up`
- iPhone con Home: `Home + Power`

### **Edición de Capturas (Opcional)**

Para mejorar la presentación:

1. **Recortar** - Eliminar barras de sistema innecesarias
2. **Añadir marco** - Usar mockup de dispositivo (herramientas: Figma, Sketch)
3. **Resaltar** - Círculos o flechas en elementos importantes (Photoshop, GIMP)
4. **Comprimir** - Optimizar tamaño sin perder calidad (TinyPNG, ImageOptim)

### **Herramientas Recomendadas**

- **Mockup Generator**: [Mockuphone](https://mockuphone.com/)
- **Screenshot Editor**: [Figma](https://figma.com) (gratis)
- **Annotation Tool**: [Skitch](https://evernote.com/products/skitch)
- **Compression**: [TinyPNG](https://tinypng.com/)

## 📏 Especificaciones Técnicas

- **Formato**: PNG (preferido) o JPG
- **Resolución mínima**: 1080x1920 píxeles
- **Tamaño máximo**: 2 MB por imagen
- **Nomenclatura**: Usar exactamente los nombres listados arriba
- **Orientación**: Portrait (vertical) para móvil

## ✅ Checklist de Capturas

Marcar con ✅ cuando cada captura esté lista:

### Historia #1
- [ ] 01_login_screen.png
- [ ] 02_main_menu_historial.png
- [ ] 03_historial_list.png
- [ ] 04_session_active_detail.png
- [ ] 05_multiple_sessions.png
- [ ] 06_pull_refresh.png
- [ ] 07_empty_state.png

### Historia #2
- [ ] 08_access_change_password.png
- [ ] 09_change_password_form.png
- [ ] 10_security_requirements.png
- [ ] 11_weak_password_validation.png
- [ ] 12_password_mismatch.png
- [ ] 13_wrong_current_password.png
- [ ] 14_toggle_visibility.png
- [ ] 15_loading_state.png
- [ ] 16_success_dialog.png
- [ ] 17_auto_logout.png

**Total: 17 capturas**

## 💡 Consejos para Mejores Capturas

1. **Datos de Prueba Realistas**
   - Usar nombres reales (no "Test User 1")
   - IPs realistas (no 127.0.0.1)
   - Fechas y horas coherentes

2. **Estado de la UI**
   - Batería no muy baja (>50%)
   - Conexión WiFi o datos visible
   - Hora del día coherente

3. **Contenido Visible**
   - Asegurarse que todo el texto sea legible
   - No capturar con teclado abierto (excepto si es relevante)
   - Scroll para mostrar contenido completo

4. **Consistencia**
   - Usar el mismo tema (light/dark) en todas
   - Mismo dispositivo para todas las capturas
   - Misma resolución

## 📝 Alternativa: Capturas Placeholder

Si no puedes obtener capturas reales, puedes:

1. **Usar Figma/Sketch** para crear mockups
2. **Screenshots de diseños** previos del proyecto
3. **Capturas de prueba** con datos ficticios claros

## 🔗 Referencias

- [Material Design Guidelines - Screenshots](https://material.io/design/)
- [Human Interface Guidelines - Screenshots](https://developer.apple.com/design/human-interface-guidelines/)
- [Flutter Screenshot Package](https://pub.dev/packages/screenshot)

---

**Nota**: Las capturas son evidencia crucial del examen. Asegúrate de que muestren claramente las funcionalidades implementadas.

