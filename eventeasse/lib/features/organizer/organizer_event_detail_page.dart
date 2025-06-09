import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../core/models/event.dart';
import 'organizer_locations_page.dart'; // Pastikan untuk mengimpor halaman yang sesuai
import 'organizer_edit_event_page.dart'; // Pastikan untuk mengimpor halaman edit event

class OrganizerEventDetailPage extends StatelessWidget {
  final Event event;
  const OrganizerEventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: null,
      appBar: AppBar(
        title: Text(event.name, style: const TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
      ),
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
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            children: [
              const SizedBox(height: 24), // Tambahkan jarak antara AppBar dan card
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.16), width: 1.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: CachedNetworkImage(
                            imageUrl: event.imageUrl != null && event.imageUrl!.isNotEmpty
                              ? 'http://localhost:3000${event.imageUrl}'
                              : 'https://placehold.co/600x400?text=Event',
                            height: 210,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 24), // Tambahkan jarak setelah gambar event
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 22),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(event.description, style: const TextStyle(fontSize: 17, color: Color(0xFF1B5E20))),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Icon(Icons.category, color: Color(0xFF388E3C), size: 20),
                                  const SizedBox(width: 8),
                                  Text('Kategori: ${event.category}', style: const TextStyle(color: Color(0xFF388E3C), fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Color(0xFF388E3C), size: 20),
                                  const SizedBox(width: 8),
                                  Text('Waktu: ${event.date}', style: const TextStyle(color: Color(0xFF388E3C), fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.attach_money, color: Color(0xFF388E3C), size: 20),
                                  const SizedBox(width: 8),
                                  Text('Harga: ${event.price} ${event.currency}', style: const TextStyle(color: Color(0xFF388E3C), fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrganizerEditEventPage(event: event),
                                      ),
                                    );
                                    if (result == true && context.mounted) {
                                      Navigator.pop(context, true); // Kembali ke list dan refresh
                                    }
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  label: const Text('Edit', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF43A047),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Hapus event
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  label: const Text('Delete', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrganizerLocationsPage(eventId: event.id),
                                ),
                              );
                            },
                            icon: const Icon(Icons.location_on, color: Colors.white),
                            label: const Text('Kelola Lokasi Penting', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF388E3C),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
