import 'package:flutter/foundation.dart';
import 'package:galonku/models/address_model.dart';
import 'package:galonku/services/address_service.dart';
import 'package:galonku/services/opencage_service.dart';
import 'package:latlong2/latlong.dart';

class StoreEntry {
  final Datum data;
  final LatLng location;
  double? distanceKm;

  StoreEntry({required this.data, required this.location});

  bool get isOpen {
    final hour = DateTime.now().hour;
    final timeOpen = hour >= 9 && hour < 21;
    final hasActiveDevice = data.devices.any((d) => d.statusDevice.toUpperCase() == 'ACTIVE');
    return timeOpen && hasActiveDevice;
  }
}

class StoresNotifier extends ChangeNotifier {
  StoresNotifier({
    AddressService? addressService,
    OpenCageService? geocoder,
    Distance? distance,
    this.displayLimit = 10,
  })  : _addressService = addressService ?? AddressService(),
        _geocoder = geocoder ?? OpenCageService(),
        _distance = distance ?? const Distance();

  final AddressService _addressService;
  final OpenCageService _geocoder;
  final Distance _distance;
  final int displayLimit;

  List<StoreEntry> _stores = const [];
  bool _loading = false;
  String? _error;

  List<StoreEntry> get stores => _stores;
  List<StoreEntry> get displayedStores =>
      _stores.length <= displayLimit ? _stores : _stores.take(displayLimit).toList();
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load({LatLng? userPosition}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final addresses = await _addressService
          .getAddresses()
          .timeout(const Duration(seconds: 15));

      final entries = await _buildEntries(addresses);
      _recomputeDistances(entries, userPosition);

      _stores = entries;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }

  void updateUserPosition(LatLng? userPosition) {
    if (_stores.isEmpty) return;
    _recomputeDistances(_stores, userPosition);
    notifyListeners();
  }

  Future<List<StoreEntry>> _buildEntries(AddressModel addresses) async {
    final tasks = addresses.data.map(_resolveEntry);
    final results = await Future.wait(tasks);
    return results.whereType<StoreEntry>().toList();
  }

  Future<StoreEntry?> _resolveEntry(Datum datum) async {
    if (datum.latitude != 0 || datum.longitude != 0) {
      return StoreEntry(
        data: datum,
        location: LatLng(datum.latitude, datum.longitude),
      );
    }

    try {
      final results = await _geocoder
          .forwardGeocode(datum.address, limit: 1)
          .timeout(const Duration(seconds: 8));
      if (results.isEmpty) return null;
      return StoreEntry(data: datum, location: results.first.location);
    } catch (_) {
      return null;
    }
  }

  void _recomputeDistances(List<StoreEntry> entries, LatLng? origin) {
    if (origin == null) {
      for (final e in entries) {
        e.distanceKm = null;
      }
      return;
    }
    for (final e in entries) {
      e.distanceKm = _distance.as(LengthUnit.Meter, origin, e.location) / 1000.0;
    }
    entries.sort((a, b) {
      final aDist = a.distanceKm ?? double.infinity;
      final bDist = b.distanceKm ?? double.infinity;
      return aDist.compareTo(bDist);
    });
  }

  @override
  void dispose() {
    _geocoder.dispose();
    super.dispose();
  }
}
