import 'dart:convert';
import 'package:http/http.dart' as http;

class ApodRepository {
  final String apiKey;

  ApodRepository({required this.apiKey});

  Future<Map<String, dynamic>> fetchApod() async {
    final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load APOD');
    }
  }
}
