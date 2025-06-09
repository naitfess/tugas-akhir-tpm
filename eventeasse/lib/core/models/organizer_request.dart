import 'package:hive/hive.dart';
part 'organizer_request.g.dart';

@HiveType(typeId: 4)
class OrganizerRequest extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String organizationName;
  @HiveField(2)
  final String organizationDesc;
  @HiveField(3)
  final String status;

  OrganizerRequest({
    required this.id,
    required this.organizationName,
    required this.organizationDesc,
    required this.status,
  });

  factory OrganizerRequest.fromJson(Map<String, dynamic> json) {
    return OrganizerRequest(
      id: json['id'],
      organizationName: json['organizationName'],
      organizationDesc: json['organizationDesc'],
      status: json['status'],
    );
  }
}
