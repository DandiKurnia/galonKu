import 'dart:convert';

import 'package:galonku/models/address_model.dart';
import 'package:galonku/services/api_client.dart';

class AddressService {
  AddressService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<AddressModel> getAddresses({int? limit}) async {
    final response = await _api.get(
      '/address',
      query: limit == null ? null : {'limit': '$limit'},
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

  Future<Datum> getAddressById(int id) async {
    final response = await _api.get('/address/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final data = json['data'];

      if (data is Map<String, dynamic>) {
        return Datum.fromJson(data);
      }
      if (data is List && data.isNotEmpty) {
        return Datum.fromJson(data.first as Map<String, dynamic>);
      }
      throw Exception('Format data alamat tidak valid');
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
