import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui';
import '../../core/services/event_service.dart';
import '../../core/models/event.dart';
import 'event_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> _events = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() { _loading = true; _error = null; });
    // TODO: Ambil token dari Hive
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final events = await EventService().getAllEvents(token);
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

  Future<void> _searchEvents() async {
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      // Only search by event name
      final events = await EventService().searchEvents(token, _searchController.text);
      setState(() {
        _events = events;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal mencari event';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: null,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.68),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.22), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.10),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Cari nama event...',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.search, color: Color(0xFF388E3C)),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                ),
                                style: const TextStyle(fontSize: 16, color: Color(0xFF1B5E20)),
                                onSubmitted: (_) => _searchEvents(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Color(0xFF388E3C)),
                              onPressed: () {
                                _searchController.clear();
                                _fetchEvents();
                              },
                              splashRadius: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : EventListPage(events: _events),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
