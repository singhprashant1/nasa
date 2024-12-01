import 'dart:convert';
import 'package:http/http.dart' as http;

class MarsRoverRepository {
  final String apiKey;

  MarsRoverRepository({required this.apiKey});

  Future<List<Map<String, dynamic>>> fetchMarsPhotos({
    required String rover,
    required String camera,
    required int sol,
  }) async {
    final url = Uri.parse(
      'https://api.nasa.gov/mars-photos/api/v1/rovers/$rover/photos?sol=$sol&camera=$camera&api_key=$apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> photos = jsonDecode(response.body)['photos'];
      return photos.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load Mars Rover Photos');
    }
  }
}
