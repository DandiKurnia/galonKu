import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/models/address_model.dart';
import 'package:galonku/services/address_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailStorePage extends StatefulWidget {
  const DetailStorePage({super.key});

  @override
  State<DetailStorePage> createState() => _DetailStorePageState();
}

class _DetailStorePageState extends State<DetailStorePage> {
  final AddressService _addressService = AddressService();

  Datum? _store;
  bool _loading = true;
  String? _errorMessage;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasFetched) return;
    _hasFetched = true;

    final l10n = AppLocalizations.of(context)!;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! int) {
      setState(() {
        _loading = false;
        _errorMessage = l10n.detailStoreInvalidId;
      });
      return;
    }
    _loadStore(args);
  }

  Future<void> _loadStore(int id) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _addressService
          .getAddressById(id)
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;
      setState(() {
        _store = result;
        _loading = false;
      });
    } catch (e, stack) {
      developer.log(
        'Failed to load store detail',
        name: 'DetailStorePage',
        error: e,
        stackTrace: stack,
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _openInMaps() async {
    final store = _store;
    if (store == null) return;
    final l10n = AppLocalizations.of(context)!;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${store.latitude},${store.longitude}',
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.openMapsFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: softColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryTextColor,
            size: 20.h,
          ),
        ),
        title: Text(
          l10n.detailStoreAppbar,
          style: primaryTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: errorColor, size: 40.h),
            SizedBox(height: 12.h),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: secondaryTextStyle.copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      );
    }

    final store = _store;
    if (store == null) return const SizedBox.shrink();

    final activeDevices = store.devices
        .where((d) => d.status.toUpperCase() == 'ACTIVE')
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroIcon(),
          SizedBox(height: 16.h),
          Text(
            store.name,
            style: primaryTextStyle.copyWith(fontSize: 18.sp, fontWeight: bold),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.location_on, size: 16.h, color: primaryColor),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  store.address,
                  style: secondaryTextStyle.copyWith(fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _machineSection(activeDevices, store),
          SizedBox(height: 24.h),
          _openMapsButton(),
        ],
      ),
    );
  }

  Widget _heroIcon() {
    return Container(
      height: 140.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.15),
            secondaryColor.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(Icons.storefront_rounded, size: 72.h, color: primaryColor),
    );
  }

  Widget _machineSection(int activeDevices, Datum store) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.precision_manufacturing_rounded,
                size: 18.h,
                color: primaryColor,
              ),
              SizedBox(width: 6.w),
              Text(
                l10n.detailStoreMachineSection(
                  '$activeDevices',
                  '${store.devices.length}',
                ),
                style: primaryTextStyle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (store.devices.isEmpty)
            Text(
              l10n.detailStoreNoMachine,
              style: secondaryTextStyle.copyWith(fontSize: 12.sp),
            )
          else
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: store.devices.map((d) {
                final active = d.status.toUpperCase() == 'ACTIVE';
                final color = active ? primaryColor : Colors.grey;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${d.name} • ${active ? l10n.machineActive : l10n.machineInactive}',
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
    );
  }

  Widget _openMapsButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: TextButton.icon(
        onPressed: _openInMaps,
        icon: Icon(Icons.map_rounded, color: whiteColor, size: 20.h),
        label: Text(
          l10n.openInMaps,
          style: headingTextStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: semiBold,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
