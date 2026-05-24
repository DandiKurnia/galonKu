import 'dart:convert';

import 'package:galonku/models/sign_in_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  static const _userKey = 'user_data';

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
}
