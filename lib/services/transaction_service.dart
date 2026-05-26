import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:galonku/models/transaction_detail_model.dart';
import 'package:galonku/models/transaction_model.dart';
import 'package:galonku/services/auth_service.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  String get _baseUrl {
    final baseUrl = dotenv.env['APP_BACKEND'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError('APP_BACKEND missing in .env');
    }
    return baseUrl;
  }

  static final http.Client _client = http.Client();
  final AuthService _authService = AuthService();

  Future<TransactionModel> getTransactions() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Sesi tidak ditemukan, silakan login kembali');
    }

    final response = await _client.get(
      Uri.parse('$_baseUrl/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractMessage(response.body, 'Gagal memuat transaksi'));
  }

  Future<TransactionDetailModel> getTransactionDetail(int id) async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Sesi tidak ditemukan, silakan login kembali');
    }

    final response = await _client.get(
      Uri.parse('$_baseUrl/transactions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return TransactionDetailModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      _extractMessage(response.body, 'Gagal memuat detail transaksi'),
    );
  }

  Future<TransactionDetailModel> createTransaction({
    required String deviceCode,
    required int totalGalon,
  }) async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Sesi tidak ditemukan, silakan login kembali');
    }

    final response = await _client.post(
      Uri.parse('$_baseUrl/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'device_code': deviceCode,
        'total_galon': totalGalon,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TransactionDetailModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      _extractMessage(response.body, 'Gagal membuat transaksi'),
    );
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
