import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class FavoriteService {
  static const String baseUrl = 'https://be-mobile-alung-1061342868557.us-central1.run.app/api/user/favorites';

  Future<List<Event>> getFavorites(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      // Ambil data event dari setiap favorite
      return data
          .where((f) => f['Event'] != null)
          .map<Event>((f) => Event.fromJson(f['Event']))
          .toList();
    }
    return [];
  }

  Future<bool> addFavorite(String token, int eventId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'eventId': eventId}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> removeFavorite(String token, int eventId) async {
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'eventId': eventId}),
    );
    return response.statusCode == 200;
  }
}
