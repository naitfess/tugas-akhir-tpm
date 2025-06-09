import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/services/organizer_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Map<String, String>> _getUserData() async {
    final box = await Hive.openBox('auth');
    final username = box.get('username') ?? '-';
    final name = box.get('name') ?? '-';
    print('[DEBUG] ProfilePage Hive: username=' + username.toString() + ', name=' + name.toString());
    if (username == '-' || name == '-') {
      // TODO: Ambil data user dari API jika perlu
    }
    return {'username': username, 'name': name};
  }

  Future<String> _getRole() async {
    final box = await Hive.openBox('auth');
    return box.get('role') ?? 'user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final data = snapshot.data!;
            return FutureBuilder<String>(
              future: _getRole(),
              builder: (context, roleSnap) {
                if (!roleSnap.hasData) return const CircularProgressIndicator();
                final role = roleSnap.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/default_profile.png')),
                    const SizedBox(height: 16),
                    Text('Username: ${data['username']}'),
                    Text('Nama: ${data['name']}'),
                    const SizedBox(height: 16),
                    const Text('Pesan & Kesan: Terima kasih telah menggunakan EventEase!'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final box = await Hive.openBox('auth');
                        await box.clear();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: const Text('Logout'),
                    ),
                    const SizedBox(height: 16),
                    if (role == 'user')
                      ElevatedButton(
                        onPressed: () async {
                          // Form apply organizer
                          final result = await showDialog(
                            context: context,
                            builder: (context) {
                              final orgNameController = TextEditingController();
                              final orgDescController = TextEditingController();
                              return AlertDialog(
                                title: const Text('Apply Organizer'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: orgNameController,
                                      decoration: const InputDecoration(labelText: 'Organization Name'),
                                    ),
                                    TextField(
                                      controller: orgDescController,
                                      decoration: const InputDecoration(labelText: 'Organization Desc'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, null),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final box = await Hive.openBox('auth');
                                      final token = box.get('token') ?? '';
                                      // TODO: Panggil API apply organizer
                                      Navigator.pop(context, {
                                        'organizationName': orgNameController.text,
                                        'organizationDesc': orgDescController.text,
                                        'token': token,
                                      });
                                    },
                                    child: const Text('Kirim'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            final success = await OrganizerService().applyOrganizer(
                              result['token'],
                              result['organizationName'],
                              result['organizationDesc'],
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengajuan organizer dikirim!')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengirim pengajuan organizer.')));
                            }
                          }
                        },
                        child: const Text('Apply Organizer'),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
