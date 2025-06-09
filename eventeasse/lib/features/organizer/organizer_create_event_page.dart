import 'package:flutter/material.dart';
import '../../core/services/event_service.dart';
import '../../core/models/event.dart';
import 'package:hive/hive.dart';

class OrganizerCreateEventPage extends StatefulWidget {
  const OrganizerCreateEventPage({Key? key}) : super(key: key);

  @override
  State<OrganizerCreateEventPage> createState() => _OrganizerCreateEventPageState();
}

class _OrganizerCreateEventPageState extends State<OrganizerCreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _timeZoneController = TextEditingController();
  final _currencyController = TextEditingController();
  final _priceController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final success = await EventService().createEvent(
        token: token,
        name: _nameController.text,
        description: _descController.text,
        category: _categoryController.text,
        date: _dateController.text,
        longitude: double.tryParse(_longitudeController.text) ?? 0,
        latitude: double.tryParse(_latitudeController.text) ?? 0,
        timeZoneLabel: _timeZoneController.text,
        currency: _currencyController.text,
        price: double.tryParse(_priceController.text) ?? 0,
      );
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() { _error = 'Gagal membuat event'; });
      }
    } catch (e) {
      setState(() { _error = 'Gagal membuat event'; });
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Event Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Event'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Tanggal (YYYY-MM-DDTHH:MM:SSZ)'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _timeZoneController,
                decoration: const InputDecoration(labelText: 'Time Zone (WIB/WIT/WITA/London)'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _currencyController,
                decoration: const InputDecoration(labelText: 'Currency (IDR/USD/dll)'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading ? const CircularProgressIndicator() : const Text('Buat Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
