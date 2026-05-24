import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/services/opencage_service.dart';
import 'package:latlong2/latlong.dart';

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

  bool _isFocused = false;
  bool _isSearching = false;
  Timer? _debounce;
  List<GeocodeResult> _suggestions = const [];

  static const LatLng _margondaDepok = LatLng(-6.3795, 106.8316);
  LatLng _markerPosition = _margondaDepok;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    _searchController.dispose();
    _geocoder.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        header(context),
        search(context),
        if (_isSearching || _suggestions.isNotEmpty) suggestionList(),
        SizedBox(height: 12.h),
        maps(),
        SizedBox(height: 12.h),
        locationStore(),
      ],
    );
  }

  Widget locationStore() {
    final stores = [
      {
        'name': 'Aqua Jakarta Timur',
        'address': 'Jl. Pendidikan No. 123, Jakarta Timur',
        'distance': '2 Km',
        'rating': '4.8',
        'open': true,
      },
      {
        'name': 'Le Minerale Cawang',
        'address': 'Jl. Mawar Raya No. 45, Cawang',
        'distance': '3 Km',
        'rating': '4.7',
        'open': true,
      },
      {
        'name': 'Aqua Cipinang',
        'address': 'Jl. Melati Indah No. 12, Cipinang',
        'distance': '4 Km',
        'rating': '4.6',
        'open': false,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          for (int i = 0; i < stores.length; i++) ...[
            _storeListItem(stores[i]),
            if (i < stores.length - 1) SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }

  Widget _storeListItem(Map<String, dynamic> store) {
    final isOpen = store['open'] as bool;
    return Container(
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
                        store['name'] as String,
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
                        color: (isOpen ? successColor : errorColor).withValues(
                          alpha: 0.12,
                        ),
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
                  store['address'] as String,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                  maxLines: 1,
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
                      store['distance'] as String,
                      style: primaryTextStyle.copyWith(
                        fontSize: 11.sp,
                        fontWeight: medium,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.star_rounded,
                      size: 12.h,
                      color: Color(0xffFFC107),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      store['rating'] as String,
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
    );
  }

  Container maps() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 210.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1),
      ),
      child: FlutterMap(
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
          MarkerLayer(
            markers: [
              Marker(
                point: _markerPosition,
                width: 40,
                height: 40,
                child: Icon(Icons.location_on, color: primaryColor, size: 40),
              ),
            ],
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
      title: Text(
        AppLocalizations.of(context)!.tileAppbar,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: transparentColor,
    );
  }
}
