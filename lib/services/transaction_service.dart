import 'dart:convert';

import 'package:galonku/models/transaction_detail_model.dart';
import 'package:galonku/models/transaction_model.dart';
import 'package:galonku/services/api_client.dart';

class TransactionService {
  TransactionService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<TransactionModel> getTransactions() async {
    final response = await _api.get('/transactions');

    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractMessage(response.body, 'Gagal memuat transaksi'));
  }

  Future<TransactionDetailModel> getTransactionDetail(int id) async {
    final response = await _api.get('/transactions/$id');

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
    final response = await _api.post(
      '/transactions',
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
