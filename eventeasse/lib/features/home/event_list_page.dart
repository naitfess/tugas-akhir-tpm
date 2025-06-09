import 'package:flutter/material.dart';
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
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.name),
          subtitle: Text(event.category),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(event: event),
              ),
            );
          },
        );
      },
    );
  }
}
