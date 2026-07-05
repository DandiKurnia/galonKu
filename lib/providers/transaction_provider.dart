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

  int _currentPage = 1;
  int _totalPages = 1;
  bool _loadingMore = false;

  List<Datum> get transactions => _transactions;
  bool get loading => _loading;
  String? get error => _error;
  TransactionFilter get filter => _filter;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get loadingMore => _loadingMore;

  List<Datum> get filteredTransactions {
    if (_filter == TransactionFilter.all) return _transactions;
    final target = _statusOf(_filter);
    return _transactions
        .where((tx) => tx.status.toUpperCase() == target)
        .toList();
  }

  Future<void> load({int? limit, bool silent = false}) async {
    if (!silent) {
      _loading = true;
      _error = null;
      notifyListeners();
    } else {
      _error = null;
    }
    _currentPage = 1;

    try {
      final result = await _service
          .getTransactions(limit: limit ?? 10, page: 1)
          .timeout(const Duration(seconds: 15));
      _transactions = result.data;
      _totalPages = result.meta?.totalPages ?? 1;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore({int? limit}) async {
    if (_loading || _loadingMore || _currentPage >= _totalPages) {
      return;
    }

    _loadingMore = true;
    _error = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final result = await _service
          .getTransactions(limit: limit ?? 10, page: nextPage)
          .timeout(const Duration(seconds: 15));
      _transactions = [..._transactions, ...result.data];
      _currentPage = nextPage;
      _totalPages = result.meta?.totalPages ?? 1;
      _loadingMore = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _loadingMore = false;
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
