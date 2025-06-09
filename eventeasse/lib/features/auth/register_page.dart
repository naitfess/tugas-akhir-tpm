import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final auth = AuthService();
    final result = await auth.register(
      _nameController.text,
      _usernameController.text,
      _passwordController.text,
      _confirmPasswordController.text,
    );
    setState(() { _loading = false; });
    if (result != null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() { _error = 'Register gagal. Cek data Anda.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: null,
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
      ),
      body: Stack(
        children: [
          // Background gradient pastel
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFB2FFFD), Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Daftar Akun EventEase',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.78),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0xFF43A047).withOpacity(0.22), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.13),
                                blurRadius: 32,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nama',
                                    prefixIcon: const Icon(Icons.badge, color: Color(0xFF388E3C)),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFF43A047), width: 1.2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFFB2FF59), width: 1.2),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 17, color: Color(0xFF1B5E20)),
                                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: const Icon(Icons.person, color: Color(0xFF388E3C)),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFF43A047), width: 1.2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFFB2FF59), width: 1.2),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 17, color: Color(0xFF1B5E20)),
                                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF388E3C)),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFF43A047), width: 1.2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFFB2FF59), width: 1.2),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 17, color: Color(0xFF1B5E20)),
                                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Password',
                                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF388E3C)),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFF43A047), width: 1.2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(color: Color(0xFFB2FF59), width: 1.2),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 17, color: Color(0xFF1B5E20)),
                                  validator: (v) => v != _passwordController.text ? 'Password tidak sama' : null,
                                ),
                                if (_error != null) ...[
                                  const SizedBox(height: 16),
                                  Text(_error!, style: const TextStyle(color: Colors.red)),
                                ],
                                const SizedBox(height: 28),
                                ElevatedButton(
                                  onPressed: _loading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                    backgroundColor: const Color(0xFF43A047),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    elevation: 0,
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  child: _loading
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : const Text('Register', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 18),
                                OutlinedButton(
                                  onPressed: _loading ? null : () => Navigator.pushNamed(context, '/login'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    side: const BorderSide(color: Color(0xFF43A047), width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  child: const Text('Sudah punya akun? Login', style: TextStyle(color: Color(0xFF43A047))),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
