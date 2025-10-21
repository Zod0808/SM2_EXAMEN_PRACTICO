import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/historial_sesion_viewmodel.dart';
import '../../models/historial_sesion_model.dart';

class HistorialSesionesView extends StatefulWidget {
  const HistorialSesionesView({Key? key}) : super(key: key);

  @override
  _HistorialSesionesViewState createState() => _HistorialSesionesViewState();
}

class _HistorialSesionesViewState extends State<HistorialSesionesView> {
  @override
  void initState() {
    super.initState();
    // Cargar historial cuando se inicializa la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistorialSesionViewModel>().cargarHistorial();
    });
  }

  Future<void> _refreshHistorial() async {
    await context.read<HistorialSesionViewModel>().cargarHistorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Inicios de Sesión'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHistorial,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer<HistorialSesionViewModel>(
        builder: (context, viewModel, child) {
          // Estado de carga
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Cargando historial...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Estado de error
          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _refreshHistorial,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado vacío
          if (viewModel.historial.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay registros de sesiones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Los inicios de sesión se registrarán automáticamente',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Lista con historial
          return RefreshIndicator(
            onRefresh: _refreshHistorial,
            child: Column(
              children: [
                // Header con estadísticas
                _buildHeaderStats(viewModel),
                
                // Lista de sesiones
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: viewModel.historial.length,
                    itemBuilder: (context, index) {
                      final sesion = viewModel.historial[index];
                      return _buildSesionCard(sesion);
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

  /// Header con estadísticas
  Widget _buildHeaderStats(HistorialSesionViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.history,
            label: 'Total',
            value: viewModel.historial.length.toString(),
            color: Colors.blue,
          ),
          _buildStatItem(
            icon: Icons.circle,
            label: 'Activas',
            value: viewModel.cantidadSesionesActivas.toString(),
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.check_circle_outline,
            label: 'Cerradas',
            value: viewModel.sesionesCerradas.length.toString(),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Card para cada sesión
  Widget _buildSesionCard(HistorialSesion sesion) {
    final isActiva = sesion.sesionActiva;
    final cardColor = isActiva ? Colors.green[50] : Colors.grey[50];
    final iconColor = isActiva ? Colors.green : Colors.grey;
    final icon = isActiva ? Icons.circle : Icons.check_circle_outline;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActiva ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: iconColor,
          radius: 24,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          '${sesion.nombreUsuario} (${sesion.rol})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, sesion.fechaFormateada),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.language, 'IP: ${sesion.direccionIp}'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.phone_android, sesion.dispositivoInfo),
            if (sesion.fechaHoraCierre != null) ...[
              const SizedBox(height: 4),
              _buildInfoRow(
                Icons.logout,
                'Cerrado: ${sesion.fechaCierreFormateada}',
              ),
            ],
            const SizedBox(height: 8),
            Text(
              sesion.tiempoTranscurrido,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            sesion.estadoTexto,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isActiva ? Colors.green[100] : Colors.grey[300],
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          side: BorderSide.none,
        ),
      ),
    );
  }

  /// Fila de información con icono
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}

