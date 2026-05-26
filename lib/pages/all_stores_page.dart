import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/models/address_model.dart';
import 'package:galonku/services/address_service.dart';

class AllStoresPage extends StatefulWidget {
  const AllStoresPage({super.key});

  @override
  State<AllStoresPage> createState() => _AllStoresPageState();
}

class _AllStoresPageState extends State<AllStoresPage> {
  final AddressService _addressService = AddressService();

  AddressModel? _addressModel;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _addressService
          .getAddresses()
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        _addressModel = result;
        _loading = false;
      });
    } catch (e, stack) {
      developer.log(
        'Failed to load all stores',
        name: 'AllStoresPage',
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: softColor,
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
          l10n.allStoresAppbar,
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
    final l10n = AppLocalizations.of(context)!;

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
            SizedBox(height: 12.h),
            TextButton(
              onPressed: _loadStores,
              child: Text(
                l10n.tryAgain,
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

    final stores = _addressModel?.data ?? const <Datum>[];
    if (stores.isEmpty) {
      return Center(
        child: Text(
          l10n.storeEmpty,
          style: secondaryTextStyle.copyWith(fontSize: 12.sp),
        ),
      );
    }

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _loadStores,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        itemCount: stores.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _storeCard(stores[index]),
      ),
    );
  }

  Widget _storeCard(Datum store) {
    final l10n = AppLocalizations.of(context)!;
    final activeDevices = store.devices
        .where((d) => d.status.toUpperCase() == 'ACTIVE')
        .length;
    final isOpen = activeDevices > 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail-store',
          arguments: store.id,
        );
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
                          store.name,
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
                          isOpen ? l10n.storeOpen : l10n.storeClosed,
                          style: (isOpen ? successTextStyle : errorTextStyle)
                              .copyWith(fontSize: 9.sp, fontWeight: semiBold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    store.address,
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
                        Icons.precision_manufacturing_rounded,
                        size: 12.h,
                        color: primaryColor,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        l10n.storeMachineCount(
                          '$activeDevices',
                          '${store.devices.length}',
                        ),
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
}
