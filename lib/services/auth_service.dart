import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:galonku/models/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Dilempar saat sesi benar-benar tidak bisa diselamatkan lagi
/// (refresh token tidak ada, sudah kadaluarsa, atau di-revoke backend).
/// Pemanggil sebaiknya mengarahkan user untuk login ulang.
class SessionExpiredException implements Exception {
  SessionExpiredException([this.message = 'Sesi berakhir, silakan login kembali']);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? _defaultClient;

  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';

  /// Refresh dianggap perlu beberapa detik sebelum exp asli, supaya token
  /// tidak kebetulan kadaluarsa di tengah jalan request.
  static const _expiryLeeway = Duration(seconds: 10);

  static final http.Client _defaultClient = http.Client();
  final http.Client _client;

  /// Single-flight lock untuk refresh. Static agar berlaku se-aplikasi:
  /// semua service membuat instance AuthService-nya sendiri, jadi tanpa ini
  /// dua request 401 yang barengan bisa memicu dua refresh dengan refresh
  /// token lama yang sama -> backend mendeteksi reuse -> semua sesi di-revoke.
  static Future<String>? _refreshInFlight;

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
    await prefs.setString(_refreshTokenKey, data.refreshToken);
    await prefs.setString(_userKey, jsonEncode(data.user.toJson()));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Mengembalikan access token yang dijamin masih berlaku.
  ///
  /// Kalau access token tersimpan sudah (hampir) kadaluarsa, otomatis tukar
  /// dengan refresh token lebih dulu. Melempar [SessionExpiredException] kalau
  /// tidak ada token sama sekali atau refresh gagal.
  Future<String> getValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw SessionExpiredException();
    }
    if (!isTokenExpired(token)) return token;
    return refreshTokens();
  }

  /// Menukar refresh token dengan pasangan token baru lewat `POST /auth/refresh`.
  ///
  /// Backend me-rotasi refresh token: token lama langsung di-revoke dan
  /// diterbitkan pasangan baru, jadi kedua token hasil wajib disimpan. Dijaga
  /// single-flight via [_refreshInFlight] supaya panggilan paralel hanya
  /// memicu satu request jaringan dan berbagi hasilnya — mencegah pengiriman
  /// refresh token lama dua kali yang akan memicu reuse detection.
  Future<String> refreshTokens() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = _performRefresh();
    _refreshInFlight = future;
    // Lepas lock begitu selesai (sukses atau gagal) supaya refresh berikutnya
    // bisa jalan lagi dengan refresh token terbaru. Error asli tetap diantar ke
    // pemanggil lewat `future`; future turunan whenComplete ini di-ignore agar
    // error-nya tidak terlapor sebagai unhandled async error.
    future.whenComplete(() {
      if (identical(_refreshInFlight, future)) _refreshInFlight = null;
    }).ignore();
    return future;
  }

  Future<String> _performRefresh() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await clearSession();
      throw SessionExpiredException();
    }

    late final http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        // Backend memakai camelCase untuk body refresh (AuthRefreshDto).
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    } catch (_) {
      // Gagal jaringan: jangan hapus sesi, biarkan dicoba lagi nanti.
      throw SessionExpiredException('Gagal menyegarkan sesi, periksa koneksi');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final newAccess = body['access_token'] as String?;
      final newRefresh = body['refresh_token'] as String?;
      if (newAccess == null || newRefresh == null) {
        await clearSession();
        throw SessionExpiredException();
      }
      await _saveTokens(newAccess, newRefresh);
      return newAccess;
    }

    // 401 (invalid/expired/reuse-detected) atau status lain: sesi tidak bisa
    // diselamatkan, bersihkan agar user diarahkan login ulang.
    await clearSession();
    throw SessionExpiredException(
      _extractMessage(response.body, 'Sesi berakhir, silakan login kembali'),
    );
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    return User.fromJson(jsonDecode(userString));
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty && !isTokenExpired(token);
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = jsonDecode(payload);
      if (payloadMap is! Map<String, dynamic>) return true;

      final exp = payloadMap['exp'];
      if (exp is! int) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      // Anggap kadaluarsa sedikit lebih awal supaya ada waktu refresh sebelum
      // token benar-benar ditolak backend.
      return !expiry.isAfter(DateTime.now().add(_expiryLeeway));
    } catch (_) {
      return true;
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
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
