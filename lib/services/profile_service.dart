import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:galonku/models/user_profile_model.dart';
import 'package:galonku/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileService {
  String get _baseUrl {
    final baseUrl = dotenv.env['APP_BACKEND'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('APP_BACKEND missing in .env');
    }
    return baseUrl;
  }

  static final client = http.Client();
  final AuthService _authService = AuthService();

  static const _supportedInputExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'avif',
    'heic',
    'heif',
  };

  Future<ProfileModel> getProfile() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Sesi tidak ditemukan, silakan login kembali');
    }

    final response = await client.get(
      Uri.parse('$_baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractMessage(response.body, 'Gagal memuat profil'));
  }

  Future<ProfileModel> updateProfile(
    String name,
    String email,
    String phoneNumber,
    File? imageFile,
  ) async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Sesi tidak ditemukan, silakan login kembali');
    }

    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$_baseUrl/profile'),
    )
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['phone_number'] = phoneNumber;

    if (imageFile != null) {
      _ensureSupportedInput(imageFile.path);
      final webpBytes = await _convertToWebp(imageFile);
      request.files.add(
        http.MultipartFile.fromBytes(
          'avatar',
          webpBytes,
          filename: 'avatar.webp',
          contentType: MediaType('image', 'webp'),
        ),
      );
    }

    final streamed = await client.send(request);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractMessage(response.body, 'Gagal memperbarui profil'));
  }

  void _ensureSupportedInput(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (!_supportedInputExtensions.contains(ext)) {
      throw Exception(
        'Format gambar tidak didukung. Gunakan jpg, jpeg, png, gif, webp, avif, atau heic',
      );
    }
  }

  Future<Uint8List> _convertToWebp(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      format: CompressFormat.webp,
      quality: 80,
      minWidth: 1024,
      minHeight: 1024,
    );
    if (result == null) {
      throw Exception('Gagal mengompres gambar');
    }
    return result;
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
