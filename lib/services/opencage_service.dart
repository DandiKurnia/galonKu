import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodeResult {
  final String formatted;
  final LatLng location;

  const GeocodeResult({required this.formatted, required this.location});
}

class OpenCageService {
  static const String _baseUrl = 'https://api.opencagedata.com/geocode/v1/json';

  final http.Client _client;

  OpenCageService({http.Client? client}) : _client = client ?? http.Client();

  String get _apiKey {
    final key = dotenv.env['OPENCAGE_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('OPENCAGE_API_KEY missing in .env');
    }
    return key;
  }

  Future<List<GeocodeResult>> forwardGeocode(
    String query, {
    int limit = 5,
    String countryCode = 'id',
    String language = 'id',
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': trimmed,
        'key': _apiKey,
        'limit': '$limit',
        'countrycode': countryCode,
        'language': language,
        'no_annotations': '1',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('OpenCage error ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (body['results'] as List?) ?? const [];

    return results.map((raw) {
      final item = raw as Map<String, dynamic>;
      final geometry = item['geometry'] as Map<String, dynamic>;
      return GeocodeResult(
        formatted: item['formatted'] as String? ?? '',
        location: LatLng(
          (geometry['lat'] as num).toDouble(),
          (geometry['lng'] as num).toDouble(),
        ),
      );
    }).toList();
  }

  void dispose() => _client.close();
}
