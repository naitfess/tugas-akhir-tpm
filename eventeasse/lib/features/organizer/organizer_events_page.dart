import 'package:flutter/material.dart';
import '../../core/services/event_service.dart';
import '../../core/models/event.dart';
import 'organizer_event_detail_page.dart';
import 'organizer_create_event_page.dart';
import 'package:hive/hive.dart';

class OrganizerEventsPage extends StatefulWidget {
  const OrganizerEventsPage({Key? key}) : super(key: key);

  @override
  State<OrganizerEventsPage> createState() => _OrganizerEventsPageState();
}

class _OrganizerEventsPageState extends State<OrganizerEventsPage> {
  List<Event> _events = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMyEvents();
  }

  Future<void> _fetchMyEvents() async {
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final events = await EventService().getMyEvents(token);
      setState(() {
        _events = events;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat event';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.category),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrganizerEventDetailPage(event: event),
                          ),
                        );
                        if (result == true) {
                          _fetchMyEvents();
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizerCreateEventPage(),
            ),
          );
          if (result == true) {
            _fetchMyEvents();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Event',
      ),
    );
  }
}
