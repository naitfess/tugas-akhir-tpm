import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class LocationService {
  static const String baseUrl = 'http://localhost:3000/api/location';

  Future<List<Location>> getLocationsByEvent(String token, int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/event/$eventId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Location.fromJson(e)).toList();
    }
    return [];
  }
}
