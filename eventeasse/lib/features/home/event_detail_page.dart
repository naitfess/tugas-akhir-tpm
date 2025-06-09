import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/models/event.dart';
import '../../core/models/location.dart';
import '../../core/services/location_service.dart';
import '../../core/services/currency_service.dart';
import '../../core/services/timezone_converter.dart';
import 'package:geolocator/geolocator.dart';
import 'navigation_page.dart';
import '../../core/services/favorite_service.dart';
import 'package:hive/hive.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;
  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  List<Location> importantLocations = [];
  bool loading = true;
  String? error;
  Position? userPosition;
  double? convertedPrice;
  String? convertedTime;
  String selectedCurrency = 'IDR';
  String selectedTimezone = 'WIB';
  final List<String> currencyOptions = ['IDR', 'USD', 'EUR', 'JPY', 'AUD'];
  final List<String> timezoneOptions = ['WIB', 'WITA', 'WIT', 'London'];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _getUserLocation();
    _convertPrice();
    _convertTime();
  }

  Future<void> _fetchLocations() async {
    try {
      // TODO: Ambil token dari Hive
      final token = '';
      final locations = await LocationService().getLocationsByEvent(token, widget.event.id);
      setState(() {
        importantLocations = locations;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Gagal memuat lokasi penting';
        loading = false;
      });
    }
  }

  Future<void> _getUserLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      setState(() { userPosition = pos; });
    } catch (_) {}
  }

  Future<void> _convertPrice() async {
    if (widget.event.currency != selectedCurrency) {
      final result = await CurrencyService().convert(widget.event.currency, selectedCurrency, widget.event.price);
      setState(() { convertedPrice = result; });
    } else {
      setState(() { convertedPrice = widget.event.price; });
    }
  }

  void _convertTime() {
    convertedTime = TimezoneConverter.convertToTimezone(widget.event.date, selectedTimezone);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.name)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(widget.event.description),
                    const SizedBox(height: 8),
                    Text('Kategori: ${widget.event.category}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Zona Waktu: '),
                        DropdownButton<String>(
                          value: selectedTimezone,
                          items: timezoneOptions.map((tz) => DropdownMenuItem(value: tz, child: Text(tz))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() { selectedTimezone = val; });
                              _convertTime();
                            }
                          },
                        ),
                      ],
                    ),
                    Text('Waktu: $convertedTime'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Mata Uang: '),
                        DropdownButton<String>(
                          value: selectedCurrency,
                          items: currencyOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() { selectedCurrency = val; });
                              _convertPrice();
                            }
                          },
                        ),
                      ],
                    ),
                    Text('Harga: ${widget.event.price} ${widget.event.currency}'
                        '${convertedPrice != null ? ' (~$convertedPrice $selectedCurrency)' : ''}'),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(double.parse(widget.event.latitude), double.parse(widget.event.longitude)),
                          zoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(double.parse(widget.event.latitude), double.parse(widget.event.longitude)),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                              ...importantLocations.map((loc) => Marker(
                                    point: LatLng(double.parse(loc.latitude), double.parse(loc.longitude)),
                                    width: 30,
                                    height: 30,
                                    child: const Icon(Icons.place, color: Colors.blue, size: 30),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (userPosition != null)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationPage(
                                    from: LatLng(userPosition!.latitude, userPosition!.longitude),
                                    to: LatLng(double.parse(widget.event.latitude), double.parse(widget.event.longitude)),
                                    destinationName: widget.event.name,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Navigasi ke Event'),
                          ),
                          ...importantLocations.map((loc) => ElevatedButton(
                                onPressed: () {
                                  if (userPosition != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavigationPage(
                                          from: LatLng(userPosition!.latitude, userPosition!.longitude),
                                          to: LatLng(double.parse(loc.latitude), double.parse(loc.longitude)),
                                          destinationName: loc.name,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Navigasi ke ${loc.name}'),
                              )),
                        ],
                      ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final box = await Hive.openBox('auth');
                            final token = box.get('token') ?? '';
                            await FavoriteService().addFavorite(token, widget.event.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke favorit!')));
                          },
                          child: const Text('Tambah ke Favorit'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final box = await Hive.openBox('auth');
                            final token = box.get('token') ?? '';
                            await FavoriteService().removeFavorite(token, widget.event.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit!')));
                          },
                          child: const Text('Hapus dari Favorit'),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
