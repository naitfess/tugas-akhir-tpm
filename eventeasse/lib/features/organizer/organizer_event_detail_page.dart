import 'package:flutter/material.dart';
import '../../core/models/event.dart';
import 'organizer_locations_page.dart'; // Pastikan untuk mengimpor halaman yang sesuai
import 'organizer_edit_event_page.dart'; // Pastikan untuk mengimpor halaman edit event

class OrganizerEventDetailPage extends StatelessWidget {
  final Event event;
  const OrganizerEventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description),
            const SizedBox(height: 8),
            Text('Kategori: ${event.category}'),
            const SizedBox(height: 8),
            Text('Waktu: ${event.date}'),
            const SizedBox(height: 8),
            Text('Harga: ${event.price} ${event.currency}'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
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
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Hapus event
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrganizerLocationsPage(eventId: event.id),
                  ),
                );
              },
              child: const Text('Kelola Lokasi Penting'),
            ),
          ],
        ),
      ),
    );
  }
}
