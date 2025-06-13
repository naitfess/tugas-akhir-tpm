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
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

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
      extendBodyBehindAppBar: true,
      backgroundColor: null,
      body: Stack(
        children: [
          // Background gradient pastel
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFB2FFFD), Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Konten utama
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 60, bottom: 12),
              children: [
                // Event image at the top, rounded, shadow
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.13),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: CachedNetworkImage(
                      imageUrl: widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty
                          ? 'https://be-mobile-alung-1061342868557.us-central1.run.app${widget.event.imageUrl}'
                          : 'https://placehold.co/600x300?text=Event',
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        width: double.infinity,
                        height: 210,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 210,
                        color: Colors.grey[300],
                        child: const Icon(Icons.event, size: 60),
                      ),
                    ),
                  ),
                ),
                // Glassmorphism Card utama
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.13),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.68),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.32), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama event
                            Text(
                              widget.event.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Deskripsi
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _circleIcon(Icons.music_note),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.event.description,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF388E3C)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Kategori
                            Row(
                              children: [
                                _circleIcon(Icons.category),
                                const SizedBox(width: 12),
                                const Text('Kategori: ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF388E3C))),
                                Text(widget.event.category, style: const TextStyle(color: Color(0xFF1B5E20))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Divider
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              height: 1.2,
                              color: const Color(0xFFB2FF59).withOpacity(0.5),
                            ),
                            // Zona waktu & waktu
                            Row(
                              children: [
                                _circleIcon(Icons.access_time),
                                const SizedBox(width: 12),
                                const Text('Zona Waktu: ', style: TextStyle(color: Color(0xFF1B5E20))),
                                DropdownButton<String>(
                                  value: selectedTimezone,
                                  underline: const SizedBox(),
                                  borderRadius: BorderRadius.circular(18),
                                  style: const TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.bold),
                                  items: timezoneOptions.map((tz) => DropdownMenuItem(value: tz, child: Text(tz))).toList(),
                                  onChanged: (val) {
                                    if (val != null) { setState(() { selectedTimezone = val; }); }
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 52, top: 2),
                              child: Text('Waktu: $convertedTime', style: const TextStyle(color: Color(0xFF388E3C), fontSize: 15)),
                            ),
                            const SizedBox(height: 12),
                            // Mata uang & harga
                            Row(
                              children: [
                                _circleIcon(Icons.attach_money),
                                const SizedBox(width: 12),
                                const Text('Mata Uang: ', style: TextStyle(color: Color(0xFF1B5E20))),
                                DropdownButton<String>(
                                  value: selectedCurrency,
                                  underline: const SizedBox(),
                                  borderRadius: BorderRadius.circular(18),
                                  style: const TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.bold),
                                  items: currencyOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (val) {
                                    if (val != null) { setState(() { selectedCurrency = val; }); }
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 52, top: 2),
                              child: Text(
                                'Harga: ${widget.event.price} ${widget.event.currency}'
                                '${convertedPrice != null ? ' (~$convertedPrice $selectedCurrency)' : ''}',
                                style: const TextStyle(color: Color(0xFF388E3C), fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Map dalam card membulat
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.10),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: SizedBox(
                      height: 220,
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
                  ),
                ),
                // Tombol aksi utama besar, gradient, membulat, shadow
                Row(
                  children: [
                    Expanded(
                      child: _modernButton(
                        icon: Icons.navigation,
                        label: 'Navigasi ke Event',
                        onPressed: userPosition != null
                            ? () {
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
                              }
                            : null,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43A047), Color(0xFF388E3C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Tombol favorit dan hapus favorit
                Row(
                  children: [
                    Expanded(
                      child: _modernButton(
                        icon: Icons.favorite,
                        label: 'Tambah ke Favorit',
                        onPressed: () async {
                          final box = await Hive.openBox('auth');
                          final token = box.get('token') ?? '';
                          await FavoriteService().addFavorite(token, widget.event.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke favorit!')));
                        },
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43A047), Color(0xFFB2FF59)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _modernButton(
                        icon: Icons.delete,
                        label: 'Hapus dari Favorit',
                        onPressed: () async {
                          final box = await Hive.openBox('auth');
                          final token = box.get('token') ?? '';
                          await FavoriteService().removeFavorite(token, widget.event.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit!')));
                        },
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFFF8A80)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          // Tombol back modern di pojok kiri atas, selalu di atas konten
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 14,
            child: Material(
              color: Colors.transparent,
              elevation: 8,
              borderRadius: BorderRadius.circular(18),
              shadowColor: Colors.black26,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Material(
                    color: Colors.white.withOpacity(0.65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_rounded, color: Color(0xFF388E3C), size: 28),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk icon dalam lingkaran glass
  Widget _circleIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Icon(icon, color: const Color(0xFF388E3C), size: 22),
      ),
    );
  }

  // Widget helper untuk tombol modern besar
  Widget _modernButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Gradient gradient,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.13),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
