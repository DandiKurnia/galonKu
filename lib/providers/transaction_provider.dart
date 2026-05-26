import 'package:flutter/foundation.dart';
import 'package:galonku/models/transaction_model.dart';
import 'package:galonku/services/transaction_service.dart';

enum TransactionFilter { all, pending, paid, expired, failed }

class TransactionProvider extends ChangeNotifier {
  TransactionProvider({TransactionService? service})
    : _service = service ?? TransactionService();

  final TransactionService _service;

  List<Datum> _transactions = const [];
  bool _loading = false;
  String? _error;
  TransactionFilter _filter = TransactionFilter.all;

  List<Datum> get transactions => _transactions;
  bool get loading => _loading;
  String? get error => _error;
  TransactionFilter get filter => _filter;

  List<Datum> get filteredTransactions {
    if (_filter == TransactionFilter.all) return _transactions;
    final target = _statusOf(_filter);
    return _transactions
        .where((tx) => tx.status.toUpperCase() == target)
        .toList();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service
          .getTransactions()
          .timeout(const Duration(seconds: 15));
      _transactions = result.data;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _loading = false;
      notifyListeners();
    }
  }

  void setFilter(TransactionFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  String _statusOf(TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.pending:
        return 'PENDING';
      case TransactionFilter.paid:
        return 'PAID';
      case TransactionFilter.expired:
        return 'EXPIRED';
      case TransactionFilter.failed:
        return 'FAILED';
      case TransactionFilter.all:
        return '';
    }
  }
}
