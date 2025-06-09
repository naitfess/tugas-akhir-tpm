import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<Event>> getAllEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/event'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Event>> searchEvents(String token, String name, String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/event/search?name=$name&category=$category'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Event>> getNearbyEvents(String token, double longitude, double latitude, double radius) async {
    final response = await http.get(
      Uri.parse('$baseUrl/event/nearby?longitude=$longitude&latitude=$latitude&radius=$radius'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    }
    return [];
  }

  Future<Event?> getEventById(String token, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/event/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<Event>> getMyEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/organizer/my-events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> createEvent({
    required String token,
    required String name,
    required String description,
    required String category,
    required String date,
    required double longitude,
    required double latitude,
    required String timeZoneLabel,
    required String currency,
    required double price,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/organizer/event'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'category': category,
        'date': date,
        'longitude': longitude,
        'latitude': latitude,
        'time_zone_label': timeZoneLabel, // snake_case
        'currency': currency,
        'price': price,
      }),
    );
    return response.statusCode == 201;
  }

  Future<bool> editEvent({
    required String token,
    required int id,
    required String name,
    required String description,
    required String category,
    required String date,
    required double longitude,
    required double latitude,
    required String timeZoneLabel,
    required String currency,
    required double price,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/organizer/event/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'category': category,
        'date': date,
        'longitude': longitude,
        'latitude': latitude,
        'time_zone_label': timeZoneLabel, // snake_case
        'currency': currency,
        'price': price,
      }),
    );
    return response.statusCode == 200;
  }
}
