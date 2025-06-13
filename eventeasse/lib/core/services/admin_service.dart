import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/organizer_request.dart';

class AdminService {
  static const String baseUrl = 'https://be-mobile-alung-1061342868557.us-central1.run.app/api/admin';

  Future<List<OrganizerRequest>> getOrganizerRequests(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/organizer-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => OrganizerRequest.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> approveOrganizer(String token, int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/organizer-requests/$id/approve'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  Future<bool> rejectOrganizer(String token, int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/organizer-requests/$id/reject'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
