import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
  static const String baseUrl =
      'http://localhost'; // Or your actual IP if testing on real devices

  Future<String> getResponse(String query) async {
    try {
      final encodedQuery = Uri.encodeQueryComponent(query);
      final uri = Uri.parse('$baseUrl/query/?query=$encodedQuery');

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      // Use bodyBytes with UTF-8 decoding
      final responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);

        // Handle raw Unicode characters
        return jsonResponse['final_response']
            .replaceAll(r'\u{2211}', '∑') // Summation symbol
            .replaceAll(r'\u{00D7}', '×'); // Multiplication symbol
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }
}
