import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../core/models/event.dart';
import 'event_detail_page.dart';

class EventListPage extends StatelessWidget {
  final List<Event> events;
  const EventListPage({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('Tidak ada event'));
    }
    return ListView.builder(
      itemCount: events.length,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: Colors.white.withOpacity(0.68),
                borderRadius: BorderRadius.circular(24),
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(event: event),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFB2FF59).withOpacity(0.18), width: 1.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.09),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: event.imageUrl != null && event.imageUrl!.isNotEmpty
                              ? 'https://be-mobile-alung-1061342868557.us-central1.run.app${event.imageUrl}'
                              : 'https://placehold.co/100x100?text=Event',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(width: 48, height: 48, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                            errorWidget: (context, url, error) => const Icon(Icons.event),
                          ),
                        ),
                      ),
                      title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), fontSize: 18)),
                      subtitle: Text(event.category, style: const TextStyle(color: Color(0xFF388E3C), fontSize: 15)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF388E3C), size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
