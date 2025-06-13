import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/services/favorite_service.dart';
import '../../core/models/event.dart';
import 'package:hive/hive.dart';
import 'dart:ui';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Event> _favorites = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() { _loading = true; _error = null; });
    final box = await Hive.openBox('auth');
    final token = box.get('token') ?? '';
    try {
      final favs = await FavoriteService().getFavorites(token);
      setState(() {
        _favorites = favs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat favorit';
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
        title: const Text('Favorite', style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
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
          // Tambahkan jarak antara AppBar dan konten
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : ListView.builder(
                              itemCount: _favorites.length,
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                              itemBuilder: (context, index) {
                                final event = _favorites[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                      child: Material(
                                        color: Colors.white.withOpacity(0.72),
                                        borderRadius: BorderRadius.circular(24),
                                        elevation: 0,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(24),
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.16), width: 1.1),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green.withOpacity(0.08),
                                                  blurRadius: 18,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(14.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white.withOpacity(0.85),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.green.withOpacity(0.10),
                                                          blurRadius: 8,
                                                          offset: const Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: event.imageUrl != null && event.imageUrl!.isNotEmpty
                                                            ? 'https://be-mobile-alung-1061342868557.us-central1.run.app/${event.imageUrl}'
                                                            : 'https://placehold.co/100x100?text=Event',
                                                        width: 56,
                                                        height: 56,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => const SizedBox(width: 56, height: 56, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                                                        errorWidget: (context, url, error) => const Icon(Icons.event, size: 36, color: Color(0xFFB2FF59)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 18)),
                                                        const SizedBox(height: 4),
                                                        Text(event.category, style: const TextStyle(color: Color(0xFF388E3C), fontSize: 15, fontWeight: FontWeight.w500)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 18.0, left: 8.0),
                                                  child: Icon(Icons.arrow_forward_ios, color: const Color(0xFF388E3C), size: 22),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
