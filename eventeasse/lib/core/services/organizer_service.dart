import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizerService {
  static const String baseUrl = 'https://be-mobile-alung-1061342868557.us-central1.run.app/api/organizer/apply';

  Future<bool> applyOrganizer(String token, String orgName, String orgDesc) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'organizationName': orgName,
        'organizationDesc': orgDesc,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
