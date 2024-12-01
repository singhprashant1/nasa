import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nasa/database/cache_database.dart';

class ApodRepository {
  final String apiKey;
  final CacheDatabase cacheDatabase;

  ApodRepository({required this.apiKey, required this.cacheDatabase});

  Future<Map<String, dynamic>> fetchAPOD() async {
    final endpoint = 'https://api.nasa.gov/planetary/apod?api_key=$apiKey';

    // Check for cached data
    final cachedData = await cacheDatabase.getCache(endpoint);
    if (cachedData != null) {
      return jsonDecode(cachedData);
    }

    try {
      // Fetch data from API
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Cache the response
        await cacheDatabase.saveCache(endpoint, responseBody);
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to fetch APOD data.');
      }
    } catch (_) {
      // Return cached data if available during errors
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
      throw Exception('No data available offline.');
    }
  }
}
