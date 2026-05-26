import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapNotifier extends ChangeNotifier {
  static const LatLng _defaultCenter = LatLng(-6.3795, 106.8316);

  LatLng _markerPosition = _defaultCenter;
  LatLng? _userPosition;
  bool _locating = false;

  LatLng get markerPosition => _markerPosition;
  LatLng? get userPosition => _userPosition;
  bool get locating => _locating;

  void setMarker(LatLng position) {
    if (_markerPosition == position) return;
    _markerPosition = position;
    notifyListeners();
  }

  Future<String?> locate() async {
    if (_locating) return null;
    developer.log('Tombol lokasi ditekan', name: 'MapNotifier');

    _locating = true;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      developer.log(
        'GPS service enabled: $serviceEnabled',
        name: 'MapNotifier',
      );
      if (!serviceEnabled) {
        return 'Aktifkan layanan lokasi untuk melanjutkan';
      }

      var permission = await Geolocator.checkPermission();
      developer.log('Permission saat ini: $permission', name: 'MapNotifier');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        developer.log(
          'Permission setelah request: $permission',
          name: 'MapNotifier',
        );
        if (permission == LocationPermission.denied) {
          return 'Izin lokasi ditolak';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        developer.log('Permission diblokir permanen', name: 'MapNotifier');
        return 'Izin lokasi diblokir. Buka pengaturan untuk mengaktifkannya.';
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      developer.log(
        'Lokasi didapat: lat=${position.latitude}, lng=${position.longitude}, '
        'accuracy=${position.accuracy}m',
        name: 'MapNotifier',
      );

      final latLng = LatLng(position.latitude, position.longitude);
      _userPosition = latLng;
      _markerPosition = latLng;
      return null;
    } catch (e, stack) {
      developer.log(
        'Gagal mendapatkan lokasi',
        name: 'MapNotifier',
        error: e,
        stackTrace: stack,
      );
      return 'Gagal mendapatkan lokasi: $e';
    } finally {
      _locating = false;
      notifyListeners();
    }
  }
}
