import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/models/address_model.dart';
import 'package:galonku/services/address_service.dart';
import 'package:galonku/services/opencage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class _StoreEntry {
  final Datum data;
  final LatLng location;
  double? distanceKm;

  _StoreEntry({required this.data, required this.location});

  bool get isOpen => data.devices.any((d) => d.status.toUpperCase() == 'ACTIVE');
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final OpenCageService _geocoder = OpenCageService();
  final AddressService _addressService = AddressService();
  final Distance _distance = const Distance();

  bool _isFocused = false;
  bool _isSearching = false;
  Timer? _debounce;
  List<GeocodeResult> _suggestions = const [];

  static const LatLng _margondaDepok = LatLng(-6.3795, 106.8316);
  LatLng _markerPosition = _margondaDepok;
  LatLng? _userPosition;
  bool _locatingUser = false;

  List<_StoreEntry> _stores = const [];
  bool _loadingStores = true;
  String? _storesError;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    _locateMe(moveCamera: true);
    _loadStores();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    _searchController.dispose();
    _geocoder.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = const [];
        _isSearching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(value);
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isSearching = true);
    try {
      final results = await _geocoder.forwardGeocode(query);
      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = const [];
        _isSearching = false;
      });
    }
  }

  void _selectSuggestion(GeocodeResult result) {
    FocusScope.of(context).unfocus();
    setState(() {
      _markerPosition = result.location;
      _searchController.text = result.formatted;
      _suggestions = const [];
    });
    _mapController.move(result.location, 16);
  }

  Future<void> _loadStores() async {
    setState(() {
      _loadingStores = true;
      _storesError = null;
    });

    try {
      final addresses = await _addressService.getAddresses();
      final entries = <_StoreEntry>[];

      for (final datum in addresses.data) {
        LatLng? location;

        if (datum.latitude != 0 || datum.longitude != 0) {
          location = LatLng(datum.latitude, datum.longitude);
        } else {
          try {
            final results = await _geocoder.forwardGeocode(
              datum.address,
              limit: 1,
            );
            if (results.isNotEmpty) location = results.first.location;
          } catch (_) {
            // skip — store akan dilewati kalau geocoding gagal
          }
        }

        if (location == null) continue;
        entries.add(_StoreEntry(data: datum, location: location));
      }

      _recomputeDistances(entries);

      if (!mounted) return;
      setState(() {
        _stores = entries;
        _loadingStores = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _storesError = e.toString();
        _loadingStores = false;
      });
    }
  }

  void _recomputeDistances(List<_StoreEntry> entries) {
    final origin = _userPosition;
    if (origin == null) {
      for (final e in entries) {
        e.distanceKm = null;
      }
      return;
    }
    for (final e in entries) {
      e.distanceKm = _distance.as(LengthUnit.Kilometer, origin, e.location);
    }
    entries.sort((a, b) {
      final aDist = a.distanceKm ?? double.infinity;
      final bDist = b.distanceKm ?? double.infinity;
      return aDist.compareTo(bDist);
    });
  }

  Future<void> _locateMe({bool moveCamera = true}) async {
    if (_locatingUser) return;
    developer.log(
      'Tombol lokasi ditekan',
      name: 'LocationPage',
    );
    setState(() => _locatingUser = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      developer.log(
        'GPS service enabled: $serviceEnabled',
        name: 'LocationPage',
      );
      if (!serviceEnabled) {
        _showLocationMessage('Aktifkan layanan lokasi untuk melanjutkan');
        return;
      }

      var permission = await Geolocator.checkPermission();
      developer.log(
        'Permission saat ini: $permission',
        name: 'LocationPage',
      );
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        developer.log(
          'Permission setelah request: $permission',
          name: 'LocationPage',
        );
        if (permission == LocationPermission.denied) {
          _showLocationMessage('Izin lokasi ditolak');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        developer.log(
          'Permission diblokir permanen',
          name: 'LocationPage',
        );
        _showLocationMessage(
          'Izin lokasi diblokir. Buka pengaturan untuk mengaktifkannya.',
        );
        return;
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
        name: 'LocationPage',
      );

      if (!mounted) return;
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _userPosition = latLng;
        _markerPosition = latLng;
        if (_stores.isNotEmpty) {
          final updated = List<_StoreEntry>.from(_stores);
          _recomputeDistances(updated);
          _stores = updated;
        }
      });
      if (moveCamera) {
        _mapController.move(latLng, 16);
      }
    } catch (e, stack) {
      developer.log(
        'Gagal mendapatkan lokasi',
        name: 'LocationPage',
        error: e,
        stackTrace: stack,
      );
      _showLocationMessage('Gagal mendapatkan lokasi: $e');
    } finally {
      if (mounted) setState(() => _locatingUser = false);
    }
  }

  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showStoreSheet(_StoreEntry entry) {
    final isOpen = entry.isOpen;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.data.name,
                    style: primaryTextStyle.copyWith(
                      fontSize: 15.sp,
                      fontWeight: bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: (isOpen ? successColor : errorColor).withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isOpen ? 'Buka' : 'Tutup',
                    style: (isOpen ? successTextStyle : errorTextStyle)
                        .copyWith(fontSize: 10.sp, fontWeight: semiBold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              entry.data.address,
              style: secondaryTextStyle.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              'Mesin (${entry.data.devices.length})',
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: semiBold,
              ),
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: entry.data.devices.map((d) {
                final active = d.status.toUpperCase() == 'ACTIVE';
                final color = active ? primaryColor : Colors.grey;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    d.name,
                    style: primaryTextStyle.copyWith(
                      fontSize: 11.sp,
                      fontWeight: medium,
                      color: color,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
            controller: _scrollController,
            children: [
              header(context),
              search(context),
              if (_isSearching || _suggestions.isNotEmpty) suggestionList(),
              SizedBox(height: 12.h),
              maps(),
              SizedBox(height: 12.h),
              locationStore(),
              SizedBox(height: 100.h),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: _isScrolled ? whiteColor : transparentColor,
            height: MediaQuery.of(context).padding.top,
          ),
        ),
      ],
    );
  }

  Widget locationStore() {
    if (_loadingStores) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (_storesError != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: errorColor, size: 32.h),
            SizedBox(height: 8.h),
            Text(
              _storesError!,
              textAlign: TextAlign.center,
              style: secondaryTextStyle.copyWith(fontSize: 11.sp),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: _loadStores,
              child: Text(
                'Coba lagi',
                style: primaryTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: semiBold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_stores.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            'Belum ada toko tersedia',
            style: secondaryTextStyle.copyWith(fontSize: 12.sp),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          for (int i = 0; i < _stores.length; i++) ...[
            _storeListItem(_stores[i]),
            if (i < _stores.length - 1) SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }

  Widget _storeListItem(_StoreEntry entry) {
    final isOpen = entry.isOpen;
    final distanceLabel = entry.distanceKm == null
        ? '-'
        : '${entry.distanceKm!.toStringAsFixed(1)} Km';

    return GestureDetector(
      onTap: () {
        setState(() => _markerPosition = entry.location);
        _mapController.move(entry.location, 17);
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withValues(alpha: 0.15),
                    secondaryColor.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: primaryColor,
                size: 28.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.data.name,
                          style: primaryTextStyle.copyWith(
                            fontSize: 13.sp,
                            fontWeight: semiBold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: (isOpen ? successColor : errorColor)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          isOpen ? 'Buka' : 'Tutup',
                          style: (isOpen ? successTextStyle : errorTextStyle)
                              .copyWith(fontSize: 9.sp, fontWeight: semiBold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    entry.data.address,
                    style: secondaryTextStyle.copyWith(
                      fontSize: 11.sp,
                      fontWeight: regular,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 12.h,
                        color: primaryColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        distanceLabel,
                        style: primaryTextStyle.copyWith(
                          fontSize: 11.sp,
                          fontWeight: medium,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.precision_manufacturing_rounded,
                        size: 12.h,
                        color: primaryColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${entry.data.devices.length} mesin',
                        style: primaryTextStyle.copyWith(
                          fontSize: 11.sp,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 14.h,
                color: whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container maps() {
    final markers = <Marker>[
      for (final store in _stores)
        Marker(
          point: store.location,
          width: 36,
          height: 36,
          child: GestureDetector(
            onTap: () {
              setState(() => _markerPosition = store.location);
              _mapController.move(store.location, 17);
              _showStoreSheet(store);
            },
            child: Container(
              decoration: BoxDecoration(
                color: store.isOpen ? primaryColor : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor, width: 2),
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: whiteColor,
                size: 18,
              ),
            ),
          ),
        ),
      Marker(
        point: _markerPosition,
        width: 40,
        height: 40,
        child: Icon(Icons.location_on, color: primaryColor, size: 40),
      ),
      if (_userPosition != null)
        Marker(
          point: _userPosition!,
          width: 24,
          height: 24,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: whiteColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 210.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1),
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _margondaDepok,
              initialZoom: 16,
              minZoom: 3,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.galonku.app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
            right: 12.w,
            bottom: 12.h,
            child: Material(
              color: whiteColor,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _locatingUser ? null : () => _locateMe(),
                child: Padding(
                  padding: EdgeInsets.all(10.h),
                  child: _locatingUser
                      ? SizedBox(
                          width: 18.h,
                          height: 18.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                      : Icon(
                          Icons.my_location_rounded,
                          color: primaryColor,
                          size: 20.h,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget suggestionList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _isSearching
          ? Padding(
              padding: EdgeInsets.all(12.h),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.3)),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.place_outlined, color: primaryColor),
                  title: Text(
                    item.formatted,
                    style: primaryTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _selectSuggestion(item),
                );
              },
            ),
    );
  }

  Widget search(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused ? primaryColor : Colors.grey.withValues(alpha: 0.5),
          width: _isFocused ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Row(
          children: [
            Icon(Icons.search, color: primaryColor, size: 24.h),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                style: primaryTextStyle,
                onChanged: _onQueryChanged,
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.of(context)!.searchLocation,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _suggestions = const []);
                },
                child: Icon(Icons.close, size: 20.h, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: Text(
        AppLocalizations.of(context)!.tileAppbar,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: transparentColor,
      surfaceTintColor: transparentColor,
      scrolledUnderElevation: 0,
    );
  }
}
