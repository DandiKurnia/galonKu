import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:galonku/models/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  static const _userKey = 'user_data';

  static final http.Client _client = http.Client();

  String get _baseUrl {
    final baseUrl = dotenv.env['APP_BACKEND'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('APP_BACKEND missing in .env');
    }
    return baseUrl;
  }

  Future<SignInModel> signIn(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SignInModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractMessage(response.body, 'Gagal masuk'));
  }

  Future<SignInModel> signUp(String name, String email, String password) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return SignInModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractMessage(response.body, 'Gagal mendaftar'));
  }

  Future<void> saveSession(SignInModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, data.accessToken);
    await prefs.setString(_userKey, jsonEncode(data.user.toJson()));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    return User.fromJson(jsonDecode(userString));
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
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
