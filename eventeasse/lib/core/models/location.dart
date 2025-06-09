import 'package:hive/hive.dart';
part 'location.g.dart';

@HiveType(typeId: 2)
class Location extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int eventId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String longitude;
  @HiveField(4)
  final String latitude;
  @HiveField(5)
  final String type;

  Location({
    required this.id,
    required this.eventId,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      eventId: json['eventId'],
      name: json['name'],
      longitude: json['longitude'].toString(),
      latitude: json['latitude'].toString(),
      type: json['type'],
    );
  }
}
