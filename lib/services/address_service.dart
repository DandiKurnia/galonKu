import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:galonku/models/address_model.dart';
import 'package:galonku/services/auth_service.dart';
import 'package:http/http.dart' as http;

class AddressService {
  String get _baseUrl {
    final baseUrl = dotenv.env['APP_BACKEND'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('APP_BACKEND missing in .env');
    }
    return baseUrl;
  }

  static final client = http.Client();
  final AuthService _authService = AuthService();

  Future<AddressModel> getAddresses() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Sesi tidak ditemukan, silakan login kembali');
    }

    final response = await client.get(
      Uri.parse('$_baseUrl/address'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final data = json['data'];

      if (data is! List) {
        throw Exception('Format data alamat tidak valid');
      }

      final addresses = data
          .map((item) => Datum.fromJson(item as Map<String, dynamic>))
          .toList();

      return AddressModel(data: addresses);
    }

    throw Exception(_extractMessage(response.body, 'Gagal memuat alamat'));
  }

  String _extractMessage(String responseBody, String fallback) {
    try {
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse is Map && jsonResponse['message'] != null) {
        final msg = jsonResponse['message'];
        return msg is List ? msg.join(', ') : msg.toString();
      }
    } catch (_) {}
    return fallback;
  }
}
