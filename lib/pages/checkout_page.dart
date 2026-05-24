import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _quantity = 1;
  final int _pricePerGallon = 6000;

  String _formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String? qrData =
        ModalRoute.of(context)?.settings.arguments as String?;
    final String machineInfo = qrData ?? 'Mesin 01';
    final int subtotal = _quantity * _pricePerGallon;

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
          l10n.checkoutAppbar,
          style: primaryTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              children: [
                _heroGallon(),
                SizedBox(height: 16.h),
                _productCard(l10n),
                SizedBox(height: 16.h),
                _sectionTitle(l10n.fillLocation),
                SizedBox(height: 8.h),
                _locationCard(machineInfo),
                SizedBox(height: 16.h),
                _summaryCard(l10n, subtotal),
                SizedBox(height: 24.h),
              ],
            ),
          ),
          _bottomBar(l10n, subtotal),
        ],
      ),
    );
  }

  Widget _heroGallon() {
    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            secondaryColor.withValues(alpha: 0.18),
            primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop, size: 12.h, color: primaryColor),
                  SizedBox(width: 4.w),
                  Text(
                    '19 Liter',
                    style: primaryTextStyle.copyWith(
                      fontSize: 10.sp,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset('assets/images/galon.png', height: 180.h, fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _productCard(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.subTextGalon,
                  style: primaryTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Rp ${_formatCurrency(_pricePerGallon)}',
                  style: headingBlueTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
          ),
          _quantitySelector(),
        ],
      ),
    );
  }

  Widget _quantitySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyButton(
            icon: Icons.remove_rounded,
            enabled: _quantity > 1,
            onTap: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
          ),
          SizedBox(
            width: 32.w,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                fontSize: 14.sp,
                fontWeight: bold,
              ),
            ),
          ),
          _qtyButton(
            icon: Icons.add_rounded,
            enabled: true,
            onTap: () => setState(() => _quantity++),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
          color: enabled ? primaryColor : backgroundColor3,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 14.h, color: whiteColor),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: primaryTextStyle.copyWith(fontSize: 13.sp, fontWeight: bold),
      ),
    );
  }

  Widget _locationCard(String machineInfo) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: primaryColor,
              size: 22.h,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aqua Jakarta Timur',
                  style: primaryTextStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Jl. Pendidikan No. 123  ·  $machineInfo',
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(AppLocalizations l10n, int subtotal) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _summaryRow(
            label: '${l10n.subTextGalon} x $_quantity',
            value: 'Rp ${_formatCurrency(subtotal)}',
          ),
          SizedBox(height: 8.h),
          Container(height: 1, color: backgroundColor3),
          SizedBox(height: 8.h),
          _summaryRow(
            label: l10n.total,
            value: 'Rp ${_formatCurrency(subtotal)}',
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (highlight ? primaryTextStyle : secondaryTextStyle).copyWith(
            fontSize: highlight ? 13.sp : 12.sp,
            fontWeight: highlight ? bold : regular,
          ),
        ),
        Text(
          value,
          style: (highlight ? headingBlueTextStyle : primaryTextStyle).copyWith(
            fontSize: highlight ? 14.sp : 12.sp,
            fontWeight: highlight ? bold : semiBold,
          ),
        ),
      ],
    );
  }

  Widget _bottomBar(AppLocalizations l10n, int subtotal) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.subtotal,
                style: secondaryTextStyle.copyWith(
                  fontSize: 11.sp,
                  fontWeight: regular,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Rp ${_formatCurrency(subtotal)}',
                style: primaryTextStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 160.w,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    'amount': subtotal,
                    'quantity': _quantity,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.pay,
                    style: headingTextStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: bold,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: whiteColor,
                    size: 18.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
