const express = require('express');
const router = express.Router();
const HistorialSesion = require('../schemas/historialSesionSchema');

// Middleware de autenticación (ajustar según tu implementación)
// Si no tienes authMiddleware, puedes comentar estas líneas temporalmente
// const authMiddleware = require('../middleware/authMiddleware');

/**
 * POST /historial-sesiones
 * Registrar un nuevo inicio de sesión
 */
router.post('/', async (req, res) => {
  try {
    const {
      usuarioId,
      nombreUsuario,
      rol,
      fechaHoraInicio,
      direccionIp,
      dispositivoInfo
    } = req.body;

    // Validar campos requeridos
    if (!usuarioId || !nombreUsuario || !rol || !direccionIp || !dispositivoInfo) {
      return res.status(400).json({
        success: false,
        message: 'Faltan campos requeridos'
      });
    }

    // Crear nuevo registro de sesión
    const nuevoHistorial = new HistorialSesion({
      usuarioId,
      nombreUsuario,
      rol,
      fechaHoraInicio: fechaHoraInicio || new Date(),
      direccionIp,
      dispositivoInfo,
      sesionActiva: true
    });

    await nuevoHistorial.save();

    console.log(`✅ Inicio de sesión registrado para: ${nombreUsuario} (${rol})`);

    res.status(201).json({
      success: true,
      sesionId: nuevoHistorial._id,
      message: 'Inicio de sesión registrado exitosamente',
      data: nuevoHistorial
    });
  } catch (error) {
    console.error('❌ Error registrando inicio de sesión:', error);
    res.status(500).json({
      success: false,
      message: 'Error al registrar inicio de sesión',
      error: error.message
    });
  }
});

/**
 * PATCH /historial-sesiones/:sesionId/cerrar
 * Registrar el cierre de una sesión
 */
router.patch('/:sesionId/cerrar', async (req, res) => {
  try {
    const { sesionId } = req.params;
    const { fechaHoraCierre } = req.body;

    // Buscar la sesión
    const sesion = await HistorialSesion.findById(sesionId);

    if (!sesion) {
      return res.status(404).json({
        success: false,
        message: 'Sesión no encontrada'
      });
    }

    // Actualizar la sesión
    sesion.fechaHoraCierre = fechaHoraCierre || new Date();
    sesion.sesionActiva = false;
    await sesion.save();

    console.log(`✅ Cierre de sesión registrado: ${sesionId}`);

    res.json({
      success: true,
      message: 'Cierre de sesión registrado exitosamente',
      data: sesion
    });
  } catch (error) {
    console.error('❌ Error registrando cierre de sesión:', error);
    res.status(500).json({
      success: false,
      message: 'Error al registrar cierre de sesión',
      error: error.message
    });
  }
});

/**
 * GET /historial-sesiones/usuario/:usuarioId
 * Obtener el historial de sesiones de un usuario
 */
router.get('/usuario/:usuarioId', async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const limite = parseInt(req.query.limite) || 50;

    // Obtener historial del usuario
    const historial = await HistorialSesion.obtenerHistorialUsuario(usuarioId, limite);

    console.log(`✅ Historial obtenido para usuario ${usuarioId}: ${historial.length} registros`);

    res.json({
      success: true,
      historial: historial,
      total: historial.length
    });
  } catch (error) {
    console.error('❌ Error obteniendo historial:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener historial',
      error: error.message
    });
  }
});

/**
 * GET /historial-sesiones/activas/:usuarioId
 * Obtener solo las sesiones activas de un usuario
 */
router.get('/activas/:usuarioId', async (req, res) => {
  try {
    const { usuarioId } = req.params;

    const sesionesActivas = await HistorialSesion.obtenerSesionesActivas(usuarioId);

    console.log(`✅ Sesiones activas para usuario ${usuarioId}: ${sesionesActivas.length}`);

    res.json({
      success: true,
      sesiones: sesionesActivas,
      total: sesionesActivas.length
    });
  } catch (error) {
    console.error('❌ Error obteniendo sesiones activas:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener sesiones activas',
      error: error.message
    });
  }
});

/**
 * DELETE /historial-sesiones/:sesionId
 * Eliminar un registro de sesión (solo para administradores)
 */
router.delete('/:sesionId', async (req, res) => {
  try {
    const { sesionId } = req.params;

    const sesion = await HistorialSesion.findByIdAndDelete(sesionId);

    if (!sesion) {
      return res.status(404).json({
        success: false,
        message: 'Sesión no encontrada'
      });
    }

    console.log(`✅ Sesión eliminada: ${sesionId}`);

    res.json({
      success: true,
      message: 'Sesión eliminada exitosamente'
    });
  } catch (error) {
    console.error('❌ Error eliminando sesión:', error);
    res.status(500).json({
      success: false,
      message: 'Error al eliminar sesión',
      error: error.message
    });
  }
});

/**
 * GET /historial-sesiones/estadisticas/:usuarioId
 * Obtener estadísticas de sesiones de un usuario
 */
router.get('/estadisticas/:usuarioId', async (req, res) => {
  try {
    const { usuarioId } = req.params;

    const totalSesiones = await HistorialSesion.countDocuments({ usuarioId });
    const sesionesActivas = await HistorialSesion.countDocuments({ 
      usuarioId, 
      sesionActiva: true 
    });
    const sesionesCerradas = await HistorialSesion.countDocuments({ 
      usuarioId, 
      sesionActiva: false 
    });

    // Obtener última sesión
    const ultimaSesion = await HistorialSesion.findOne({ usuarioId })
      .sort({ fechaHoraInicio: -1 });

    res.json({
      success: true,
      estadisticas: {
        totalSesiones,
        sesionesActivas,
        sesionesCerradas,
        ultimaSesion
      }
    });
  } catch (error) {
    console.error('❌ Error obteniendo estadísticas:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener estadísticas',
      error: error.message
    });
  }
});

module.exports = router;

