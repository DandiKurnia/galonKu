import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/models/transaction_model.dart';
import 'package:galonku/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TransactionProvider>().load(limit: 10);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 4;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Consumer<TransactionProvider>(
            builder: (context, notifier, _) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: header(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: filterBar(context, notifier),
                    ),
                  ),
                  ..._buildContent(context, notifier),
                ],
              );
            },
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

  List<Widget> _buildContent(
    BuildContext context,
    TransactionProvider notifier,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (notifier.loading) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
        ),
      ];
    }

    if (notifier.error != null) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: errorColor, size: 40.h),
                SizedBox(height: 12.h),
                Text(
                  notifier.error!,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle.copyWith(fontSize: 12.sp),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: notifier.load,
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
          ),
        ),
      ];
    }

    final list = notifier.filteredTransactions;
    if (list.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              l10n.transactionEmpty,
              style: secondaryTextStyle.copyWith(fontSize: 12.sp),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.only(bottom: 100.h),
        sliver: SliverList.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: transactionCard(list[index]),
          ),
        ),
      ),
    ];
  }

  Widget filterBar(BuildContext context, TransactionProvider notifier) {
    final l10n = AppLocalizations.of(context)!;
    final filters = <_FilterChipData>[
      _FilterChipData(TransactionFilter.all, l10n.filterAll),
      _FilterChipData(
        TransactionFilter.pending,
        l10n.transactionStatusPending,
      ),
      _FilterChipData(TransactionFilter.paid, l10n.transactionStatusPaid),
      _FilterChipData(
        TransactionFilter.expired,
        l10n.transactionStatusExpired,
      ),
      _FilterChipData(TransactionFilter.failed, l10n.transactionStatusFailed),
    ];

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final f = filters[index];
          final isActive = notifier.filter == f.value;
          return GestureDetector(
            onTap: () => notifier.setFilter(f.value),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isActive ? primaryColor : whiteColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive ? primaryColor : backgroundColor3,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                f.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: medium,
                  color: isActive ? whiteColor : primaryTextColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget transactionCard(Datum tx) {
    final l10n = AppLocalizations.of(context)!;
    final status = tx.status.toUpperCase();
    final statusColor = _statusColor(status);
    final statusLabel = _statusLabel(l10n, status);

    final dateLabel = DateFormat(
      'd MMM y',
      'id',
    ).format(tx.createdAt.toLocal());
    final totalLabel = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(tx.totalPrice);
    final invoiceLabel = 'INV-${tx.id.toString().padLeft(5, '0')}';

    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: backgroundColor3),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              padding: EdgeInsets.all(6.h),
              decoration: BoxDecoration(
                color: softColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Image.asset(
                'assets/images/galon.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: medium,
                        color: statusColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    l10n.transactionTitle,
                    style: primaryTextStyle.copyWith(
                      fontSize: 13.sp,
                      fontWeight: semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    l10n.transactionAmount(
                      '${tx.totalGalon}',
                      tx.device?.name ?? '-',
                    ),
                    style: secondaryTextStyle.copyWith(
                      fontSize: 11.sp,
                      fontWeight: regular,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12.h,
                        color: secondaryTextColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        dateLabel,
                        style: secondaryTextStyle.copyWith(
                          fontSize: 11.sp,
                          fontWeight: regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoiceLabel,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      totalLabel,
                      style: primaryTextStyle.copyWith(
                        fontSize: 13.sp,
                        fontWeight: bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          '/transaction-detail',
                          arguments: tx.id,
                        );
                        if (!mounted) return;
                        await context.read<TransactionProvider>().load(limit: 10);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.showDetail,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: medium,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10.h,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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

  Widget header(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: Text(
        AppLocalizations.of(context)!.transactionAppbar,
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

class _FilterChipData {
  final TransactionFilter value;
  final String label;
  const _FilterChipData(this.value, this.label);
}
