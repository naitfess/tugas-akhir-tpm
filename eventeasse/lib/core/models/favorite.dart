import 'package:hive/hive.dart';
part 'favorite.g.dart';

@HiveType(typeId: 3)
class Favorite extends HiveObject {
  @HiveField(0)
  final int eventId;

  Favorite({required this.eventId});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(eventId: json['eventId']);
  }
}
