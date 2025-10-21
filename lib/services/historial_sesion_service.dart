import 'package:flutter/foundation.dart';
import '../models/historial_sesion_model.dart';
import 'api_service.dart';

class HistorialSesionService {
  final ApiService _apiService;

  HistorialSesionService(this._apiService);

  /// Registrar inicio de sesión
  /// Se llama automáticamente desde AuthViewModel al hacer login exitoso
  Future<String?> registrarInicioSesion({
    required String usuarioId,
    required String nombreUsuario,
    required String rol,
    required String direccionIp,
    required String dispositivoInfo,
  }) async {
    try {
      final response = await _apiService.post('/historial-sesiones', {
        'usuarioId': usuarioId,
        'nombreUsuario': nombreUsuario,
        'rol': rol,
        'fechaHoraInicio': DateTime.now().toUtc().toIso8601String(),
        'direccionIp': direccionIp,
        'dispositivoInfo': dispositivoInfo,
        'sesionActiva': true,
      });

      if (response['success'] == true) {
        final sesionId = response['sesionId'] ?? response['data']?['_id'];
        debugPrint('✅ Inicio de sesión registrado: $sesionId');
        return sesionId;
      } else {
        debugPrint('⚠️ No se pudo registrar inicio de sesión');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error registrando inicio de sesión: $e');
      // No lanzamos el error para no interrumpir el flujo de login
      return null;
    }
  }

  /// Registrar cierre de sesión
  /// Se llama desde AuthViewModel al hacer logout
  Future<void> registrarCierreSesion(String? sesionId) async {
    if (sesionId == null || sesionId.isEmpty) {
      debugPrint('⚠️ No hay sesionId para cerrar');
      return;
    }

    try {
      await _apiService.patch('/historial-sesiones/$sesionId/cerrar', {
        'fechaHoraCierre': DateTime.now().toUtc().toIso8601String(),
        'sesionActiva': false,
      });
      debugPrint('✅ Cierre de sesión registrado: $sesionId');
    } catch (e) {
      debugPrint('❌ Error registrando cierre de sesión: $e');
      // No lanzamos el error para no interrumpir el flujo de logout
    }
  }

  /// Obtener historial del usuario actual
  /// Se llama desde HistorialSesionViewModel
  Future<List<HistorialSesion>> obtenerHistorialUsuario(String usuarioId) async {
    try {
      final response = await _apiService.get('/historial-sesiones/usuario/$usuarioId');

      if (response['success'] == true) {
        final List<dynamic> data = response['historial'] ?? response['data'] ?? [];
        final historial = data.map((json) => HistorialSesion.fromJson(json)).toList();
        debugPrint('✅ Historial obtenido: ${historial.length} registros');
        return historial;
      } else {
        debugPrint('⚠️ No se pudo obtener historial');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error obteniendo historial: $e');
      return [];
    }
  }

  /// Obtener información del dispositivo
  /// Placeholder - se puede mejorar con package device_info_plus
  String obtenerInfoDispositivo() {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return 'Android Mobile';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return 'iOS Mobile';
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        return 'Windows Desktop';
      } else if (defaultTargetPlatform == TargetPlatform.linux) {
        return 'Linux Desktop';
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        return 'macOS Desktop';
      } else {
        return 'Unknown Platform';
      }
    } catch (e) {
      return 'Unknown Device';
    }
  }

  /// Obtener dirección IP
  /// Placeholder - se puede mejorar con package network_info_plus
  String obtenerDireccionIp() {
    // Por ahora retornamos un placeholder
    // En producción, se puede obtener la IP real usando:
    // - package: network_info_plus para IP local
    // - API externa para IP pública
    return 'Local Device';
  }
}

