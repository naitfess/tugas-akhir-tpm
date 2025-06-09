import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String longitude;
  @HiveField(6)
  final String latitude;
  @HiveField(7)
  final String timeZoneLabel;
  @HiveField(8)
  final String currency;
  @HiveField(9)
  final double price;
  @HiveField(10)
  final List<dynamic>? locations;
  @HiveField(11)
  String? imageUrl;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.date,
    required this.longitude,
    required this.latitude,
    required this.timeZoneLabel,
    required this.currency,
    required this.price,
    this.locations,
    this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      longitude: json['longitude'].toString(),
      latitude: json['latitude'].toString(),
      timeZoneLabel: json['time_zone_label'],
      currency: json['currency'],
      price: json['price'].toDouble(),
      locations: json['locations'],
      imageUrl: json['image_url'],
    );
  }
}
