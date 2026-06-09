import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:galonku/services/auth_service.dart';
import 'package:http/http.dart' as http;

/// HTTP wrapper yang mengurus autentikasi secara terpusat:
///
/// - menyuntik `Authorization: Bearer <token>` dengan token yang sudah dijamin
///   valid (refresh proaktif lewat [AuthService.getValidToken]);
/// - kalau backend tetap membalas 401 (mis. token dicabut di tengah jalan),
///   sekali mencoba refresh lalu mengulang request dengan token baru;
/// - melempar [SessionExpiredException] kalau sesi benar-benar tak bisa
///   diselamatkan, supaya pemanggil mengarahkan user untuk login ulang.
///
/// Semua service (transaction, profile, address) memakai instance ini alih-alih
/// memegang `http.Client` dan menyusun header sendiri.
class ApiClient {
  ApiClient({AuthService? authService, http.Client? client})
    : _authService = authService ?? AuthService(),
      _client = client ?? _defaultClient;

  static final http.Client _defaultClient = http.Client();

  final AuthService _authService;
  final http.Client _client;

  String get baseUrl {
    final value = dotenv.env['APP_BACKEND'];
    if (value == null || value.isEmpty) {
      throw StateError('APP_BACKEND missing in .env');
    }
    return value;
  }

  Future<http.Response> get(String path, {Map<String, String>? query}) {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query,
    );
    return _withAuthRetry((token) => _client.get(uri, headers: _headers(token)));
  }

  Future<http.Response> post(String path, {Object? body}) {
    final uri = Uri.parse('$baseUrl$path');
    return _withAuthRetry(
      (token) => _client.post(uri, headers: _headers(token), body: body),
    );
  }

  /// Varian untuk request yang harus dibangun ulang tiap percobaan
  /// (mis. [http.MultipartRequest] yang sekali pakai). [build] menerima token
  /// yang valid dan harus mengembalikan request baru tiap dipanggil.
  Future<http.Response> send(
    http.BaseRequest Function(String token) build,
  ) {
    return _withAuthRetry((token) async {
      final streamed = await _client.send(build(token));
      return http.Response.fromStream(streamed);
    });
  }

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  /// Jalankan [request] dengan token valid; kalau hasilnya 401, refresh sekali
  /// lalu ulangi tepat satu kali dengan token baru.
  Future<http.Response> _withAuthRetry(
    Future<http.Response> Function(String token) request,
  ) async {
    final token = await _authService.getValidToken();
    final response = await request(token);

    if (response.statusCode != 401) return response;

    // Token sempat valid lokal tapi backend menolak — refresh lalu coba lagi.
    // refreshTokens() melempar SessionExpiredException kalau gagal, yang
    // sengaja dibiarkan naik ke pemanggil.
    final freshToken = await _authService.refreshTokens();
    return request(freshToken);
  }
}
