import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:galonku/models/sign_in_model.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  String get _baseUrl {
    final baseUrl = dotenv.env['APP_BACKEND'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('APP_BACKEND missing in .env');
    }
    return baseUrl;
  }

  static final client = http.Client();

  Future<SignInModel> signUp(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return SignInModel.fromJson(jsonDecode(response.body));
    }

    String message = 'Gagal mendaftar';
    try {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is Map && jsonResponse['message'] != null) {
        message = jsonResponse['message'] is List
            ? (jsonResponse['message'] as List).join(', ')
            : jsonResponse['message'].toString();
      }
    } catch (_) {}
    throw Exception(message);
  }
}
