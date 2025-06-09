import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import '../../core/services/routing_service.dart';

class NavigationPage extends StatefulWidget {
  final LatLng from;
  final LatLng to;
  final String destinationName;
  const NavigationPage({Key? key, required this.from, required this.to, required this.destinationName}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  double? _direction;
  double? _distance;
  List<LatLng> _routePoints = [];
  bool _loadingRoute = true;

  @override
  void initState() {
    super.initState();
    _calculateDirectionAndDistance();
    _fetchRoute();
    FlutterCompass.events?.listen((event) {
      setState(() {
        _direction = event.heading;
      });
    });
  }

  Future<void> _fetchRoute() async {
    setState(() { _loadingRoute = true; });
    try {
      final points = await RoutingService.fetchRoute(widget.from, widget.to);
      setState(() {
        _routePoints = points;
        _loadingRoute = false;
      });
    } catch (_) {
      setState(() { _loadingRoute = false; });
    }
  }

  void _calculateDirectionAndDistance() {
    final Distance distance = const Distance();
    _distance = distance.as(LengthUnit.Meter, widget.from, widget.to);
  }

  double _calculateBearing() {
    final double lat1 = widget.from.latitude * (pi / 180.0);
    final double lon1 = widget.from.longitude * (pi / 180.0);
    final double lat2 = widget.to.latitude * (pi / 180.0);
    final double lon2 = widget.to.longitude * (pi / 180.0);
    final double dLon = lon2 - lon1;
    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final double brng = atan2(y, x);
    return (brng * 180.0 / pi + 360.0) % 360.0;
  }

  @override
  Widget build(BuildContext context) {
    final bearing = _calculateBearing();
    final heading = _direction ?? 0;
    final angle = (bearing - heading + 360) % 360;
    return Scaffold(
      appBar: AppBar(title: Text('Arah ke ${widget.destinationName}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Jarak: ${_distance?.toStringAsFixed(1) ?? '-'} meter'),
            const SizedBox(height: 24),
            Transform.rotate(
              angle: angle * pi / 180.0,
              child: const Icon(Icons.navigation, size: 100, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text('Arahkan panah ke tujuan!'),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: _loadingRoute
                  ? const Center(child: CircularProgressIndicator())
                  : FlutterMap(
                      options: MapOptions(
                        center: widget.from,
                        zoom: 14,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: widget.from,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.person_pin_circle, color: Colors.green, size: 40),
                            ),
                            Marker(
                              point: widget.to,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
