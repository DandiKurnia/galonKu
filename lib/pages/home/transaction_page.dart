import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String _selectedFilter = 'all';
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

  final List<Map<String, String>> _transactions = const [
    {
      'invoice': 'inv-23131',
      'count': '2',
      'machine': '01',
      'date': '20 Mei 2026',
      'total': 'Rp 12.000',
      'status': 'success',
    },
    {
      'invoice': 'inv-23120',
      'count': '1',
      'machine': '03',
      'date': '18 Mei 2026',
      'total': 'Rp 6.000',
      'status': 'cancelled',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'success',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'cancelled',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'success',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'success',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'cancelled',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'success',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'success',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'cancelled',
    },
    {
      'invoice': 'inv-23098',
      'count': '3',
      'machine': '02',
      'date': '15 Mei 2026',
      'total': 'Rp 18.000',
      'status': 'success',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'all'
        ? _transactions
        : _transactions.where((tx) => tx['status'] == _selectedFilter).toList();

    return Stack(
      children: [
        Positioned.fill(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 100.h),
            itemCount: filtered.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return header(context);
              }
              if (index == 1) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: filterBar(context),
                );
              }
              return Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                child: transactionCard(filtered[index - 2]),
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

  Widget filterBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = [
      {'value': 'all', 'label': l10n.filterAll},
      {'value': 'success', 'label': l10n.statusTransaction},
      {'value': 'cancelled', 'label': l10n.cancelTransaction},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Row(
        children: filters.map((f) {
          final isActive = _selectedFilter == f['value'];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f['value']!),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : whiteColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isActive ? primaryColor : backgroundColor3,
                  ),
                ),
                child: Text(
                  f['label']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: medium,
                    color: isActive ? whiteColor : primaryTextColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget transactionCard(Map<String, String> data) {
    final l10n = AppLocalizations.of(context)!;
    final isSuccess = data['status'] == 'success';
    final statusColor = isSuccess ? successColor : errorColor;
    final statusLabel = isSuccess
        ? l10n.statusTransaction
        : l10n.cancelTransaction;

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
                    l10n.transactionAmount(data['count']!, data['machine']!),
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
                        data['date']!,
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
                  data['invoice']!,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data['total']!,
                      style: primaryTextStyle.copyWith(
                        fontSize: 13.sp,
                        fontWeight: bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () {},
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
