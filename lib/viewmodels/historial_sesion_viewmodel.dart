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

  // Getters públicos
  List<HistorialSesion> get historial => _historial;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HistorialSesionViewModel(this._historialService, this._sessionService);

  /// Cargar historial del usuario actual
  Future<void> cargarHistorial() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Obtener el ID del usuario actual desde session_service
      // Nota: Esto asume que session_service tiene un método para obtener el usuario actual
      // Si no existe, se puede obtener de otra forma (por ejemplo, desde auth_viewmodel)
      
      // Por ahora usamos un placeholder - deberás ajustar esto según tu implementación
      final usuarioId = await _obtenerUsuarioIdActual();
      
      if (usuarioId != null && usuarioId.isNotEmpty) {
        _historial = await _historialService.obtenerHistorialUsuario(usuarioId);
        
        // Ordenar por fecha descendente (más reciente primero)
        _historial.sort((a, b) => b.fechaHoraInicio.compareTo(a.fechaHoraInicio));
        
        debugPrint('✅ Historial cargado: ${_historial.length} sesiones');
      } else {
        _errorMessage = 'No se pudo obtener el ID del usuario';
        debugPrint('⚠️ $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Error al cargar historial: ${e.toString()}';
      debugPrint('❌ $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener el ID del usuario actual
  /// Este método debe adaptarse a tu implementación específica
  Future<String?> _obtenerUsuarioIdActual() async {
    try {
      // Opción 1: Si session_service tiene el método
      // return await _sessionService.getCurrentUserId();
      
      // Opción 2: Si guardas el userId en SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // return prefs.getString('userId');
      
      // Opción 3: Si lo guardas en session_service como propiedad
      // return _sessionService.currentUserId;
      
      // Por ahora retornamos null - deberás implementar esto
      // según cómo manejes la sesión en tu app
      debugPrint('⚠️ Implementar _obtenerUsuarioIdActual()');
      return null;
    } catch (e) {
      debugPrint('❌ Error obteniendo usuario actual: $e');
      return null;
    }
  }

  /// Limpiar historial (para cuando el usuario cierra sesión)
  void limpiarHistorial() {
    _historial = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Filtrar sesiones activas
  List<HistorialSesion> get sesionesActivas {
    return _historial.where((sesion) => sesion.sesionActiva).toList();
  }

  /// Filtrar sesiones cerradas
  List<HistorialSesion> get sesionesCerradas {
    return _historial.where((sesion) => !sesion.sesionActiva).toList();
  }

  /// Obtener cantidad de sesiones activas
  int get cantidadSesionesActivas {
    return sesionesActivas.length;
  }
}

