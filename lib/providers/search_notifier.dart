import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:galonku/services/opencage_service.dart';

class SearchNotifier extends ChangeNotifier {
  SearchNotifier({OpenCageService? geocoder})
    : _geocoder = geocoder ?? OpenCageService();

  final OpenCageService _geocoder;

  Timer? _debounce;
  int _requestId = 0;

  List<GeocodeResult> _suggestions = const [];
  bool _isSearching = false;

  List<GeocodeResult> get suggestions => _suggestions;
  bool get isSearching => _isSearching;
  bool get hasResults => _suggestions.isNotEmpty || _isSearching;

  void onQueryChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      if (_isSearching || _suggestions.isNotEmpty) {
        _isSearching = false;
        _suggestions = const [];
        notifyListeners();
      }
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(trimmed);
    });
  }

  Future<void> _search(String query) async {
    final myId = ++_requestId;
    _isSearching = true;
    notifyListeners();

    try {
      final results = await _geocoder
          .forwardGeocode(query)
          .timeout(const Duration(seconds: 8));
      if (myId != _requestId) return;
      _suggestions = results;
      _isSearching = false;
      notifyListeners();
    } catch (_) {
      if (myId != _requestId) return;
      _suggestions = const [];
      _isSearching = false;
      notifyListeners();
    }
  }

  void clear() {
    _debounce?.cancel();
    _requestId++;
    if (_suggestions.isEmpty && !_isSearching) return;
    _suggestions = const [];
    _isSearching = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _geocoder.dispose();
    super.dispose();
  }
}
