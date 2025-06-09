import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/models/event.dart';
import '../../core/services/event_service.dart';
import 'package:hive/hive.dart';

class OrganizerEditEventPage extends StatefulWidget {
  final Event event;
  const OrganizerEditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  State<OrganizerEditEventPage> createState() => _OrganizerEditEventPageState();
}

class _OrganizerEditEventPageState extends State<OrganizerEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TextEditingController _dateController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;
  late TextEditingController _timeZoneController;
  late TextEditingController _currencyController;
  late TextEditingController _priceController;
  bool _loading = false;
  String? _error;

  final List<String> _timeZoneOptions = ['WIB', 'WITA', 'WIT', 'London'];
  final List<String> _currencyOptions = ['IDR', 'USD', 'EUR', 'JPY', 'AUD'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _descController = TextEditingController(text: widget.event.description);
    _categoryController = TextEditingController(text: widget.event.category);
    _dateController = TextEditingController(text: widget.event.date.toIso8601String());
    _longitudeController = TextEditingController(text: widget.event.longitude.toString());
    _latitudeController = TextEditingController(text: widget.event.latitude.toString());
    _timeZoneController = TextEditingController(text: widget.event.timeZoneLabel);
    _currencyController = TextEditingController(text: widget.event.currency);
    _priceController = TextEditingController(text: widget.event.price.toString());
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final success = await EventService().editEvent(
        token: token,
        id: widget.event.id,
        name: _nameController.text,
        description: _descController.text,
        category: _categoryController.text,
        date: _dateController.text,
        longitude: double.tryParse(_longitudeController.text) ?? 0,
        latitude: double.tryParse(_latitudeController.text) ?? 0,
        timeZoneLabel: _timeZoneController.text, // tetap gunakan argumen ini
        currency: _currencyController.text,
        price: double.tryParse(_priceController.text) ?? 0,
      );
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() { _error = 'Gagal mengedit event'; });
      }
    } catch (e) {
      setState(() { _error = 'Gagal mengedit event'; });
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF1B5E20))),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.16), width: 1.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Edit Event', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 22)),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Nama Event', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _descController,
                            decoration: const InputDecoration(labelText: 'Deskripsi', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _categoryController,
                            decoration: const InputDecoration(labelText: 'Kategori', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(labelText: 'Tanggal (YYYY-MM-DDTHH:MM:SSZ)', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _longitudeController,
                            decoration: const InputDecoration(labelText: 'Longitude', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _latitudeController,
                            decoration: const InputDecoration(labelText: 'Latitude', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _timeZoneController.text.isNotEmpty ? _timeZoneController.text : _timeZoneOptions[0],
                            decoration: const InputDecoration(labelText: 'Time Zone', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            items: _timeZoneOptions.map((tz) => DropdownMenuItem<String>(value: tz, child: Text(tz))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() { _timeZoneController.text = val; });
                              }
                            },
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _currencyController.text.isNotEmpty ? _currencyController.text : _currencyOptions[0],
                            decoration: const InputDecoration(labelText: 'Currency', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            items: _currencyOptions.map((c) => DropdownMenuItem<String>(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() { _currencyController.text = val; });
                              }
                            },
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'Harga', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 18),
                          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                          ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF43A047),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            child: _loading ? const CircularProgressIndicator() : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
