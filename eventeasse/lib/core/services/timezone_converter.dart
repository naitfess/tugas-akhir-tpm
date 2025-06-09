import 'package:intl/intl.dart';

class TimezoneConverter {
  static String convertToTimezone(DateTime date, String label) {
    // Mapping label ke offset
    final offsets = {
      'WIB': 7,
      'WITA': 8,
      'WIT': 9,
      'London': 0,
    };
    final offset = offsets[label] ?? 7;
    final converted = date.toUtc().add(Duration(hours: offset));
    return DateFormat('yyyy-MM-dd HH:mm').format(converted) + ' $label';
  }
}
