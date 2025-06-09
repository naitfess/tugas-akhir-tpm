import 'package:flutter/material.dart';
import '../../core/services/location_service.dart';
import '../../core/services/organizer_location_service.dart';
import '../../core/models/location.dart';
import 'package:hive/hive.dart';

class OrganizerLocationsPage extends StatefulWidget {
  final int eventId;
  const OrganizerLocationsPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<OrganizerLocationsPage> createState() => _OrganizerLocationsPageState();
}

class _OrganizerLocationsPageState extends State<OrganizerLocationsPage> {
  List<Location> _locations = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final locations = await LocationService().getLocationsByEvent(token, widget.eventId);
      setState(() {
        _locations = locations;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat lokasi penting';
        _loading = false;
      });
    }
  }

  void _showAddLocationDialog() async {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final latController = TextEditingController();
    final lngController = TextEditingController();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Lokasi Penting'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama')), 
            TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Tipe')), 
            TextField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.number),
            TextField(controller: lngController, decoration: const InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'name': nameController.text,
                'type': typeController.text,
                'latitude': double.tryParse(latController.text) ?? 0,
                'longitude': double.tryParse(lngController.text) ?? 0,
              });
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    if (result != null) {
      final box = await Hive.openBox('auth');
      final token = box.get('token') ?? '';
      await OrganizerLocationService().addLocation(
        token,
        widget.eventId,
        result['name'],
        result['type'],
        result['latitude'],
        result['longitude'],
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lokasi penting ditambahkan!')));
      _fetchLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lokasi Penting Event')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _locations.length,
                  itemBuilder: (context, index) {
                    final loc = _locations[index];
                    return ListTile(
                      title: Text(loc.name),
                      subtitle: Text('${loc.type} (${loc.latitude}, ${loc.longitude})'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              // Edit lokasi penting
                              final nameController = TextEditingController(text: loc.name);
                              final typeController = TextEditingController(text: loc.type);
                              final latController = TextEditingController(text: loc.latitude.toString());
                              final lngController = TextEditingController(text: loc.longitude.toString());
                              final result = await showDialog<Map<String, dynamic>>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Edit Lokasi Penting'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama')),
                                      TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Tipe')),
                                      TextField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.number),
                                      TextField(controller: lngController, decoration: const InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.number),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, {
                                          'name': nameController.text,
                                          'type': typeController.text,
                                          'latitude': double.tryParse(latController.text) ?? 0,
                                          'longitude': double.tryParse(lngController.text) ?? 0,
                                        });
                                      },
                                      child: const Text('Simpan'),
                                    ),
                                  ],
                                ),
                              );
                              if (result != null) {
                                final box = await Hive.openBox('auth');
                                final token = box.get('token') ?? '';
                                await OrganizerLocationService().editLocation(
                                  token,
                                  loc.id,
                                  result['name'],
                                  result['type'],
                                  result['latitude'],
                                  result['longitude'],
                                );
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lokasi penting diupdate!')));
                                _fetchLocations();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final box = await Hive.openBox('auth');
                              final token = box.get('token') ?? '';
                              await OrganizerLocationService().deleteLocation(token, loc.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lokasi penting dihapus!')));
                              _fetchLocations();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLocationDialog,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Lokasi Penting',
      ),
    );
  }
}
