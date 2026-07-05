import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/models/transaction_detail_model.dart';
import 'package:galonku/services/transaction_service.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final TransactionService _service = TransactionService();

  TransactionDetailData? _data;
  bool _loading = true;
  String? _errorMessage;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasFetched) return;
    _hasFetched = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! int) {
      setState(() {
        _loading = false;
        _errorMessage = AppLocalizations.of(context)!.detailStoreInvalidId;
      });
      return;
    }
    _load(args);
  }

  Future<void> _load(int id, {bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
    }

    try {
      final result = await _service
          .getTransactionDetail(id)
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {
        _data = result.data;
        _loading = false;
      });
    } catch (e, stack) {
      developer.log(
        'Failed to load transaction detail',
        name: 'TransactionDetailPage',
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
          l10n.transactionDetailAppbar,
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

    final id = ModalRoute.of(context)?.settings.arguments as int?;

    if (_errorMessage != null) {
      return RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          if (id != null) {
            await _load(id, silent: true);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 100.h),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 200.h,
            child: Center(
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
            ),
          ),
        ),
      );
    }

    final data = _data;
    if (data == null) return const SizedBox.shrink();

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: () async {
        await _load(data.id, silent: true);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          _statusHeader(l10n, data),
          SizedBox(height: 16.h),
          _orderSection(l10n, data),
          SizedBox(height: 12.h),
          if (data.device != null) ...[
            _locationSection(l10n, data.device!),
            SizedBox(height: 12.h),
          ],
          if (data.payment != null) ...[
            _paymentSection(l10n, data.payment!),
            SizedBox(height: 12.h),
          ],
          if (data.waterFillLogs.isNotEmpty) ...[
            _waterFillSection(l10n, data.waterFillLogs),
            SizedBox(height: 12.h),
          ],
          if (data.transactionHistories.isNotEmpty)
            _historySection(l10n, data.transactionHistories),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _statusHeader(AppLocalizations l10n, TransactionDetailData data) {
    final status = data.status.toUpperCase();
    final color = _statusColor(status);
    final dateLabel = DateFormat(
      'd MMM y, HH:mm',
      'id',
    ).format(data.createdAt.toLocal());
    final invoice = 'INV-${data.id.toString().padLeft(5, '0')}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: backgroundColor3),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              _statusLabel(l10n, status),
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: semiBold,
                color: color,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            invoice,
            style: primaryTextStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            dateLabel,
            style: secondaryTextStyle.copyWith(
              fontSize: 11.sp,
              fontWeight: regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderSection(AppLocalizations l10n, TransactionDetailData data) {
    final lines = data.transactionDetails;
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return _section(
      title: l10n.orderSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderItemTitle,
            style: primaryTextStyle.copyWith(
              fontSize: 13.sp,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(height: 6.h),
          for (final line in lines)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.orderQtyPrice(
                      '${line.galonQty}',
                      formatter.format(line.priceOneGalon),
                    ),
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12.sp,
                      fontWeight: regular,
                    ),
                  ),
                  Text(
                    formatter.format(line.subTotal),
                    style: primaryTextStyle.copyWith(
                      fontSize: 12.sp,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(height: 1, color: backgroundColor3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.orderTotal,
                style: primaryTextStyle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                formatter.format(data.totalPrice),
                style: primaryTextStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationSection(AppLocalizations l10n, DeviceDetail device) {
    final addressLine = device.address?.address ?? '-';
    return _section(
      title: l10n.locationSection,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.precision_manufacturing_rounded,
              color: primaryColor,
              size: 20.h,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: primaryTextStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  addressLine,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentSection(AppLocalizations l10n, PaymentDetail payment) {
    final status = payment.status.toUpperCase();
    final statusColor = _statusColor(status);
    final canPay = status == 'PENDING' &&
        payment.invoiceUrl != null &&
        payment.invoiceUrl!.isNotEmpty;

    return _section(
      title: l10n.paymentSectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kvRow(
            label: l10n.paymentMethodLabel,
            value: _paymentMethodLabel(l10n, payment.paymentMethod),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.paymentStatusLabel,
                style: secondaryTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: regular,
                ),
              ),
              Text(
                _statusLabel(l10n, status),
                style: primaryTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: semiBold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (payment.expiryDate != null) ...[
            SizedBox(height: 6.h),
            _kvRow(
              label: l10n.paymentExpiryLabel,
              value: DateFormat(
                'd MMM y, HH:mm',
                'id',
              ).format(payment.expiryDate!.toLocal()),
            ),
          ],
          if (canPay) ...[
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: TextButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    '/payment-invoice',
                    arguments: payment.invoiceUrl,
                  );
                  if (!mounted) return;
                  final id = _data?.id;
                  if (id != null) {
                    _hasFetched = true;
                    await _load(id);
                  }
                },
                icon: Icon(Icons.payment_rounded, color: whiteColor, size: 18.h),
                label: Text(
                  l10n.payNow,
                  style: headingTextStyle.copyWith(
                    fontSize: 13.sp,
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
            ),
          ],
        ],
      ),
    );
  }

  Widget _waterFillSection(AppLocalizations l10n, List<WaterFillLog> logs) {
    return _section(
      title: l10n.waterFillSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < logs.length; i++) ...[
            Row(
              children: [
                Icon(Icons.water_drop, color: primaryColor, size: 16.h),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.waterFillItem('${logs[i].galonNumber}'),
                    style: primaryTextStyle.copyWith(
                      fontSize: 12.sp,
                      fontWeight: medium,
                    ),
                  ),
                ),
                Text(
                  DateFormat('HH:mm', 'id').format(logs[i].createdAt.toLocal()),
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                ),
              ],
            ),
            if (i < logs.length - 1) SizedBox(height: 6.h),
          ],
        ],
      ),
    );
  }

  Widget _historySection(
    AppLocalizations l10n,
    List<TransactionHistory> histories,
  ) {
    return _section(
      title: l10n.historySection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < histories.length; i++)
            _historyTile(
              entry: histories[i],
              isFirst: i == 0,
              isLast: i == histories.length - 1,
              l10n: l10n,
            ),
        ],
      ),
    );
  }

  Widget _historyTile({
    required TransactionHistory entry,
    required bool isFirst,
    required bool isLast,
    required AppLocalizations l10n,
  }) {
    final color = _statusColor(entry.status.toUpperCase());
    final dateLabel = DateFormat(
      'd MMM y, HH:mm',
      'id',
    ).format(entry.createdAt.toLocal());

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18.w,
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 12.h,
                  margin: EdgeInsets.only(top: 4.h),
                  decoration: BoxDecoration(
                    color: isFirst ? color : whiteColor,
                    border: Border.all(color: color, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      color: backgroundColor3,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _statusLabel(l10n, entry.status.toUpperCase()),
                        style: primaryTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: semiBold,
                          color: color,
                        ),
                      ),
                      Text(
                        dateLabel,
                        style: secondaryTextStyle.copyWith(
                          fontSize: 10.sp,
                          fontWeight: regular,
                        ),
                      ),
                    ],
                  ),
                  if (entry.description.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      entry.description,
                      style: secondaryTextStyle.copyWith(
                        fontSize: 11.sp,
                        fontWeight: regular,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: backgroundColor3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: primaryTextStyle.copyWith(
              fontSize: 13.sp,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _kvRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: secondaryTextStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: regular,
          ),
        ),
        Text(
          value,
          style: primaryTextStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: medium,
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PAID':
        return successColor;
      case 'PENDING':
        return const Color(0xffF59E0B);
      case 'EXPIRED':
        return secondaryTextColor;
      case 'FAILED':
        return errorColor;
      default:
        return secondaryTextColor;
    }
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'PAID':
        return l10n.transactionStatusPaid;
      case 'PENDING':
        return l10n.transactionStatusPending;
      case 'EXPIRED':
        return l10n.transactionStatusExpired;
      case 'FAILED':
        return l10n.transactionStatusFailed;
      default:
        return status;
    }
  }

  String _paymentMethodLabel(AppLocalizations l10n, String method) {
    switch (method.toUpperCase()) {
      case 'BANK_TRANSFER':
        return l10n.paymentMethodBankTransfer;
      case 'EWALLET':
      case 'E_WALLET':
        return l10n.paymentMethodEwallet;
      case 'CREDIT_CARD':
        return l10n.paymentMethodCreditCard;
      case 'QRIS':
        return l10n.paymentMethodQris;
      default:
        return method.isEmpty ? l10n.paymentMethodOther : method;
    }
  }
}
