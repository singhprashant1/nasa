import 'dart:convert';
import 'package:http/http.dart' as http;

class EarthImageryRepository {
  final String apiKey;

  EarthImageryRepository({required this.apiKey});

  Future<String> fetchEarthImagery({
    required double latitude,
    required double longitude,
    required String date,
  }) async {
    final url = Uri.parse(
      'https://api.nasa.gov/planetary/earth/assets?lon=$longitude&lat=$latitude&date=$date&dim=0.1&api_key=$apiKey',
    );
    print("1111========$url");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['url'] != null) {
        return data['url'];
      } else {
        throw Exception('No image available for the specified parameters.');
      }
    } else {
      throw Exception('Failed to fetch Earth imagery.');
    }
  }
}
