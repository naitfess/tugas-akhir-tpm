import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<double?> convert(String from, String to, double amount) async {
    final response = await http.get(
      Uri.parse('https://api.frankfurter.dev/v1/latest?base=$from&symbols=$to'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rate = (data['rates'][to] as num?)?.toDouble();
      if (rate != null) {
        return double.parse((amount * rate).toStringAsFixed(2));
      }
    }
    return null;
  }
}
