import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://linear-regression-model-7a17.onrender.com';

  Future<Map<String, dynamic>> predictScore(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load prediction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to communicate with server: $e');
    }
  }
}
