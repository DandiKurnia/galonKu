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
      print('TransactionProvider.load: page=1, limit=${limit ?? 10}');
      final result = await _service
          .getTransactions(limit: limit ?? 10, page: 1)
          .timeout(const Duration(seconds: 15));
      _transactions = result.data;
      _totalPages = result.meta?.totalPages ?? 1;
      _loading = false;
      print('TransactionProvider.load Success: itemsCount=${_transactions.length}, totalPages=$_totalPages');
      notifyListeners();
    } catch (e) {
      print('TransactionProvider.load Error: $e');
      _error = e.toString().replaceFirst('Exception: ', '');
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore({int? limit}) async {
    print('TransactionProvider.loadMore called: _loading=$_loading, _loadingMore=$_loadingMore, _currentPage=$_currentPage, _totalPages=$_totalPages');
    if (_loading || _loadingMore || _currentPage >= _totalPages) {
      print('TransactionProvider.loadMore: Skipped fetch');
      return;
    }

    _loadingMore = true;
    _error = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      print('TransactionProvider.loadMore: Fetching page $nextPage, limit=${limit ?? 10}');
      final result = await _service
          .getTransactions(limit: limit ?? 10, page: nextPage)
          .timeout(const Duration(seconds: 15));
      _transactions = [..._transactions, ...result.data];
      _currentPage = nextPage;
      _totalPages = result.meta?.totalPages ?? 1;
      _loadingMore = false;
      print('TransactionProvider.loadMore Success: itemsCount=${_transactions.length}, newCurrentPage=$_currentPage, totalPages=$_totalPages');
      notifyListeners();
    } catch (e) {
      print('TransactionProvider.loadMore Error: $e');
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
