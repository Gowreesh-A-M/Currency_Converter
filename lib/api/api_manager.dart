import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiManager {
  // Base URL for the API
  static const String baseUrl = 'https://api.exchangerate-api.com/v4/latest/';

  // Fetch exchange rates for a given base currency
  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$baseCurrency'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
