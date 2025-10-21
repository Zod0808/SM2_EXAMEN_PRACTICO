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
      id: json['_id'] ?? json['id'] ?? '',
      usuarioId: json['usuarioId'] ?? json['usuario_id'] ?? '',
      nombreUsuario: json['nombreUsuario'] ?? json['nombre_usuario'] ?? '',
      rol: json['rol'] ?? '',
      fechaHoraInicio: json['fechaHoraInicio'] != null
          ? DateTime.parse(json['fechaHoraInicio'])
          : DateTime.now(),
      fechaHoraCierre: json['fechaHoraCierre'] != null
          ? DateTime.parse(json['fechaHoraCierre'])
          : null,
      direccionIp: json['direccionIp'] ?? json['direccion_ip'] ?? 'N/A',
      dispositivoInfo:
          json['dispositivoInfo'] ?? json['dispositivo_info'] ?? 'N/A',
      sesionActiva: json['sesionActiva'] ?? json['sesion_activa'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isEmpty ? null : id,
      'usuarioId': usuarioId,
      'nombreUsuario': nombreUsuario,
      'rol': rol,
      'fechaHoraInicio': fechaHoraInicio.toIso8601String(),
      'fechaHoraCierre': fechaHoraCierre?.toIso8601String(),
      'direccionIp': direccionIp,
      'dispositivoInfo': dispositivoInfo,
      'sesionActiva': sesionActiva,
    };
  }

  // Getters útiles para la UI
  String get fechaFormateada {
    return '${fechaHoraInicio.day.toString().padLeft(2, '0')}/${fechaHoraInicio.month.toString().padLeft(2, '0')}/${fechaHoraInicio.year} ${fechaHoraInicio.hour.toString().padLeft(2, '0')}:${fechaHoraInicio.minute.toString().padLeft(2, '0')}';
  }

  String get horaFormateada {
    return '${fechaHoraInicio.hour.toString().padLeft(2, '0')}:${fechaHoraInicio.minute.toString().padLeft(2, '0')}';
  }

  String get estadoTexto {
    return sesionActiva ? 'ACTIVA' : 'CERRADA';
  }

  String? get fechaCierreFormateada {
    if (fechaHoraCierre == null) return null;
    return '${fechaHoraCierre!.day.toString().padLeft(2, '0')}/${fechaHoraCierre!.month.toString().padLeft(2, '0')}/${fechaHoraCierre!.year} ${fechaHoraCierre!.hour.toString().padLeft(2, '0')}:${fechaHoraCierre!.minute.toString().padLeft(2, '0')}';
  }

  String get tiempoTranscurrido {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaHoraInicio);

    if (diferencia.inMinutes < 1) {
      return 'Hace ${diferencia.inSeconds} segundos';
    } else if (diferencia.inHours < 1) {
      return 'Hace ${diferencia.inMinutes} minutos';
    } else if (diferencia.inDays < 1) {
      return 'Hace ${diferencia.inHours} horas';
    } else if (diferencia.inDays < 30) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      return fechaFormateada;
    }
  }
}

