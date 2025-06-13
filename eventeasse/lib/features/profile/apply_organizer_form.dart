import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/services/organizer_service.dart';

class ApplyOrganizerForm extends StatefulWidget {
  const ApplyOrganizerForm({Key? key}) : super(key: key);

  @override
  State<ApplyOrganizerForm> createState() => _ApplyOrganizerFormState();
}

class _ApplyOrganizerFormState extends State<ApplyOrganizerForm> {
  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _orgDescController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    final success = await OrganizerService().applyOrganizer(
      token,
      _orgNameController.text.trim(),
      _orgDescController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan organizer berhasil dikirim!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim pengajuan organizer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Organizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _orgNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Organisasi',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _orgDescController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Organisasi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Kirim Pengajuan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
