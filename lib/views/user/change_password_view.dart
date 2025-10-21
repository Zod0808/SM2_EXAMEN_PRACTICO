import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

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

  /// Validar si la contraseña cumple los requisitos de seguridad
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

  /// Obtener mensaje descriptivo de requisitos faltantes
  String _getPasswordRequirementsMessage(String password) {
    List<String> missing = [];

    if (password.length < 8) {
      missing.add('Mínimo 8 caracteres');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      missing.add('Una mayúscula');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      missing.add('Un número');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      missing.add('Un carácter especial');
    }

    return missing.isEmpty ? '' : 'Falta: ${missing.join(", ")}';
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final success = await authViewModel.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (success && mounted) {
      // Mostrar diálogo de éxito
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text('Contraseña Actualizada'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu contraseña ha sido cambiada exitosamente.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Por seguridad, debes iniciar sesión nuevamente.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                authViewModel.logout(); // Cerrar sesión automáticamente
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } else if (mounted) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  authViewModel.errorMessage ?? 'Error al cambiar contraseña',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
        elevation: 0,
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
                  // Card con requisitos de seguridad
                  Card(
                    color: Colors.blue[50],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue[200]!),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.security, color: Colors.blue[700]),
                              SizedBox(width: 8),
                              Text(
                                'Requisitos de Seguridad',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          _buildRequirement('Mínimo 8 caracteres'),
                          _buildRequirement('Al menos una mayúscula (A-Z)'),
                          _buildRequirement('Al menos un número (0-9)'),
                          _buildRequirement(
                              'Al menos un carácter especial (!@#\$%^&*)'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Campo: Contraseña Actual
                  Text(
                    'Contraseña Actual',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu contraseña actual',
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña actual';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo: Nueva Contraseña
                  Text(
                    'Nueva Contraseña',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu nueva contraseña',
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onChanged: (value) {
                      setState(() {}); // Para actualizar el indicador
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su nueva contraseña';
                      }
                      if (!_isPasswordStrong(value)) {
                        return _getPasswordRequirementsMessage(value);
                      }
                      return null;
                    },
                  ),
                  // Indicador de fortaleza
                  if (_newPasswordController.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: _buildPasswordStrengthIndicator(
                        _newPasswordController.text,
                      ),
                    ),
                  SizedBox(height: 20),

                  // Campo: Confirmar Nueva Contraseña
                  Text(
                    'Confirmar Nueva Contraseña',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirma tu nueva contraseña',
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
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

                  // Botón de Cambiar Contraseña
                  SizedBox(
                    width: double.infinity,
                    child: authViewModel.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _changePassword,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(width: 8),
                                Text(
                                  'Cambiar Contraseña',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    Color color;
    String text;

    if (strength == 4) {
      color = Colors.green;
      text = 'Fuerte';
    } else if (strength == 3) {
      color = Colors.orange;
      text = 'Media';
    } else {
      color = Colors.red;
      text = 'Débil';
    }

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: strength / 4,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

