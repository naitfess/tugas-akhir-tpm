import 'package:flutter/material.dart';
import '../../core/services/favorite_service.dart';
import '../../core/models/event.dart';
import 'package:hive/hive.dart';

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
      appBar: AppBar(title: const Text('Favorite')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final event = _favorites[index];
                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.category),
                      onTap: () {
                        // TODO: Navigasi ke detail event
                      },
                    );
                  },
                ),
    );
  }
}
