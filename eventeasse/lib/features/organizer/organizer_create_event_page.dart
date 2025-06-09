import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/services/event_service.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

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
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() { _pickedImage = image; });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final success = await EventService().createEventMultipart(
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
        image: _pickedImage,
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
      appBar: AppBar(title: const Text('Buat Event Baru', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF1B5E20))),
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
                          Text('Buat Event Baru', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 22)),
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
                          TextFormField(
                            controller: _timeZoneController,
                            decoration: const InputDecoration(labelText: 'Time Zone (WIB/WIT/WITA/London)', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _currencyController,
                            decoration: const InputDecoration(labelText: 'Currency (IDR/USD/dll)', filled: true, fillColor: Color(0xFFF1F8E9), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
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
                          GestureDetector(
                            onTap: _pickImage,
                            child: _pickedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.file(
                                    File(_pickedImage!.path),
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://placehold.co/600x400?text=Event',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF43A047),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            child: const Text('Pilih Gambar Event', style: TextStyle(color: Colors.white)),
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
                            child: _loading ? const CircularProgressIndicator() : const Text('Buat Event', style: TextStyle(color: Colors.white)),
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
