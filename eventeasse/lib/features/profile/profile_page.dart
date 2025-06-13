import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../../core/services/organizer_service.dart';
import '../../core/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final _suggestionController = TextEditingController();
  bool _isSubmitting = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _getUserData() async {
    final box = await Hive.openBox('auth');
    final username = box.get('username') ?? '-';
    final name = box.get('name') ?? '-';
    final imgUrl = box.get('imgUrl') ?? '';
    print('[DEBUG] ProfilePage Hive: username=' + username.toString() + ', name=' + name.toString());
    if (username == '-' || name == '-') {
      // TODO: Ambil data user dari API jika perlu
    }
    return {'username': username, 'name': name, 'imgUrl': imgUrl};
  }

  Future<String> _getRole() async {
    final box = await Hive.openBox('auth');
    return box.get('role') ?? 'user';
  }

  Future<String> _getProfileImageUrl() async {
    final box = await Hive.openBox('auth');
    return box.get('profile_image_url') ?? '';
  }

  Future<void> _submitSuggestion() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulasi submit ke backend
    setState(() => _isSubmitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terima kasih atas saran & kesan Anda!')));
      _suggestionController.clear();
    }
  }

  Future<Map<String, dynamic>> _getProfileAll() async {
    final user = await _getUserData();
    final role = await _getRole();
    final imgUrl = await _getProfileImageUrl();
    return {'user': user, 'role': role, 'imgUrl': imgUrl};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: null,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
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
          FutureBuilder<Map<String, dynamic>>(
            future: _getProfileAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final user = snapshot.data!['user'] as Map<String, String>;
              final role = snapshot.data!['role'] as String;
              final imgUrl = snapshot.data!['imgUrl'] as String;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Avatar floating overlap card
                    Transform.translate(
                      offset: const Offset(0, 24),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFB2FF59), width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.22),
                                  blurRadius: 32,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  final box = await Hive.openBox('auth');
                                  final token = box.get('token') ?? '';
                                  final url = await AuthService().uploadProfileImage(token, image);
                                  if (url != null) {
                                    await box.put('profile_image_url', url);
                                    if (mounted) setState(() {});
                                  }
                                }
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.7),
                                    width: 128,
                                    height: 128,
                                    child: imgUrl.isNotEmpty
                                        ? CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover)
                                        : const Icon(Icons.person, size: 68, color: Color(0xFF388E3C)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Card profile floating
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.fromLTRB(32, 72, 32, 36),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.82),
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.22), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.16),
                              blurRadius: 36,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            Text(user['name'] ?? '-', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            Text('@${user['username'] ?? '-'}', style: const TextStyle(fontSize: 17, color: Color(0xFF388E3C), fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text('Role: $role', style: const TextStyle(fontSize: 15, color: Color(0xFF388E3C))),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _modernButton(
                                    icon: Icons.logout,
                                    label: 'Logout',
                                    onPressed: () async {
                                      final box = await Hive.openBox('auth');
                                      await box.clear();
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF43A047), Color(0xFFB2FF59)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (role == 'user')
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(minWidth: 180, maxWidth: 340),
                                    child: _modernButton(
                                      icon: Icons.verified_user,
                                      label: 'Apply menjadi Organizer',
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/apply-organizer');
                                      },
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF43A047), Color(0xFFB2FF59)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 32),
                            // Section Saran & Kesan (hardcode, tidak ada input)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.13), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Row(
                                    children: [
                                      Icon(Icons.feedback, color: Color(0xFF388E3C)),
                                      SizedBox(width: 8),
                                      Text('Saran & Kesan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF388E3C))),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text('"Senang belajar TPM bersama pak bagus"', style: TextStyle(fontSize: 15, color: Color(0xFF1B5E20))),
                                  SizedBox(height: 8),
                                  Text('"Saran tidak ada sih, sudah mantap!"', style: TextStyle(fontSize: 15, color: Color(0xFF1B5E20))),
                                  SizedBox(height: 8),
                                  Text('"Semoga ke depannya bisa digunakan untuk dunia kerja"', style: TextStyle(fontSize: 15, color: Color(0xFF1B5E20))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _modernButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Gradient gradient,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.13),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            splashFactory: InkRipple.splashFactory,
          ),
          icon: Icon(icon, color: Colors.white, size: 22),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
