import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:galonku/models/user_profile_model.dart';
import 'package:galonku/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileService {
  ProfileService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

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
    final response = await _api.get('/profile');

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
    // Konversi gambar sekali di luar builder supaya tidak diulang saat retry.
    Uint8List? webpBytes;
    if (imageFile != null) {
      _ensureSupportedInput(imageFile.path);
      webpBytes = await _convertToWebp(imageFile);
    }

    final uri = Uri.parse('${_api.baseUrl}/profile');
    final response = await _api.send((token) {
      final request = http.MultipartRequest('PATCH', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['phone_number'] = phoneNumber;

      if (webpBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'avatar',
            webpBytes,
            filename: 'avatar.webp',
            contentType: MediaType('image', 'webp'),
          ),
        );
      }
      return request;
    });

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
