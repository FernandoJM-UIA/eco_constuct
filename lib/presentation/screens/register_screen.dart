import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFDFBF6),
                  Color(0xFFF4F7FA),
                  Color(0xFFEFF2F6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Color(0xFF1A1A1A)),
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/login',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Crear cuenta',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFD4AF37).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.handshake,
                                    color: Color(0xFF1A1A1A)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Únete a la comunidad que rescata materiales.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (authProvider.errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                authProvider.errorMessage!,
                                style: GoogleFonts.inter(
                                  color: Colors.red[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          if (authProvider.errorMessage != null)
                            const SizedBox(height: 12),
                          _buildTextField(
                            controller: _nameController,
                            label: 'Nombre completo',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Correo electrónico',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo';
                              }
                              if (!value.contains('@')) {
                                return 'Ingrese un correo válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese una contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _PrimaryButton(
                            onTap: _register,
                            loading: isLoading,
                            label: 'Crear cuenta',
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pushReplacementNamed(
                                      context,
                                      '/login',
                                    ),
                            child: Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Más circularidad, menos desperdicio.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;
  final String label;

  const _PrimaryButton({
    required this.onTap,
    required this.loading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Opacity(
      opacity: loading ? 0.7 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
