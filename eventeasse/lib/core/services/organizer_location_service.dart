import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizerLocationService {
  static const String baseUrl = 'https://be-mobile-alung-1061342868557.us-central1.run.app/api/organizer/location';

  Future<bool> addLocation(String token, int eventId, String name, String type, double latitude, double longitude) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'eventId': eventId,
        'name': name,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> editLocation(String token, int locationId, String name, String type, double latitude, double longitude) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$locationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteLocation(String token, int locationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$locationId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
