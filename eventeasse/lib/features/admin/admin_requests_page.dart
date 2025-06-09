import 'package:flutter/material.dart';
import '../../core/services/admin_service.dart';
import '../../core/models/organizer_request.dart';
import 'package:hive/hive.dart';

class AdminRequestsPage extends StatefulWidget {
  const AdminRequestsPage({Key? key}) : super(key: key);

  @override
  State<AdminRequestsPage> createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  List<OrganizerRequest> _requests = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final reqs = await AdminService().getOrganizerRequests(token);
      setState(() {
        _requests = reqs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat request organizer';
        _loading = false;
      });
    }
  }

  Future<void> _approve(int id) async {
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    final success = await AdminService().approveOrganizer(token, id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil approve!')));
      _fetchRequests();
    }
  }

  Future<void> _reject(int id) async {
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    final success = await AdminService().rejectOrganizer(token, id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil reject!')));
      _fetchRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organizer Requests')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final req = _requests[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(req.organizationName),
                        subtitle: Text(req.organizationDesc),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approve(req.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _reject(req.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
