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
    enum: ['Guardia', 'Administrador', 'guardia', 'administrador'],
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
  timestamps: true, // Agrega createdAt y updatedAt automáticamente
  collection: 'historial_sesiones' // Nombre de la colección en MongoDB
});

// Índice compuesto para consultas eficientes por usuario y fecha
historialSesionSchema.index({ usuarioId: 1, fechaHoraInicio: -1 });

// Índice para búsquedas por sesión activa
historialSesionSchema.index({ sesionActiva: 1 });

// Método virtual para obtener duración de la sesión
historialSesionSchema.virtual('duracionSesion').get(function() {
  if (this.fechaHoraCierre) {
    return this.fechaHoraCierre - this.fechaHoraInicio;
  }
  return null;
});

// Método para cerrar la sesión
historialSesionSchema.methods.cerrarSesion = function() {
  this.fechaHoraCierre = new Date();
  this.sesionActiva = false;
  return this.save();
};

// Método estático para obtener sesiones activas de un usuario
historialSesionSchema.statics.obtenerSesionesActivas = function(usuarioId) {
  return this.find({
    usuarioId: usuarioId,
    sesionActiva: true
  }).sort({ fechaHoraInicio: -1 });
};

// Método estático para obtener historial completo de un usuario
historialSesionSchema.statics.obtenerHistorialUsuario = function(usuarioId, limite = 50) {
  return this.find({ usuarioId: usuarioId })
    .sort({ fechaHoraInicio: -1 })
    .limit(limite);
};

const HistorialSesion = mongoose.model('HistorialSesion', historialSesionSchema);

module.exports = HistorialSesion;

