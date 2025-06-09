import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api/auth';

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Simpan token ke Hive
      final box = await Hive.openBox('auth');
      await box.put('token', data['token']);
      // Simpan data user ke Hive
      if (data['user'] != null) {
        await box.put('username', data['user']['username']);
        await box.put('name', data['user']['name']);
        await box.put('role', data['user']['role']);
        print('[DEBUG] Saved to Hive: username=' + data['user']['username'].toString() + ', name=' + data['user']['name'].toString() + ', role=' + data['user']['role'].toString());
      }
      return data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> register(
      String name, String username, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<void> logout() async {
    final box = await Hive.openBox('auth');
    await box.clear();
  }

  Future<String?> getToken() async {
    final box = await Hive.openBox('auth');
    return box.get('token');
  }

  Future<String?> getRole() async {
    final box = await Hive.openBox('auth');
    return box.get('role');
  }

  Future<String?> uploadProfileImage(String token, XFile image) async {
    final uri = Uri.parse('http://localhost:3000/api/user/profile/image');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['image_url'];
    }
    return null;
  }
}
