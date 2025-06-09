import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  // Ganti dengan API key OpenRouteService Anda
  static const String apiKey = '5b3ce3597851110001cf6248cb6bb2fb93a8451db3615e7a8d1dc1b6';

  static Future<List<LatLng>> fetchRoute(LatLng from, LatLng to) async {
    final url = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coords = data['features'][0]['geometry']['coordinates'] as List;
      return coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
    }
    throw Exception('Failed to fetch route');
  }
}
