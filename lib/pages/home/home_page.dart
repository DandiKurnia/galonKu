import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
            controller: _scrollController,
            children: [
              header(context),
              headline(context),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  AppLocalizations.of(context)!.tutorial,
                  style: primaryTextStyle.copyWith(fontSize: 16.sp, fontWeight: bold),
                ),
              ),
              SizedBox(height: 12.h),
              tutorial(context),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.location,
                      style: primaryTextStyle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.findAll,
                      style: headingBlueTextStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: bold,
                      ),
                    ),
                  ],
                ),
              ),
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
    final stores = [
      {
        'name': 'Aqua Jakarta Timur',
        'address': 'Jl. Pendidikan No. 123',
        'distance': '2 Km',
        'rating': '4.8',
      },
      {
        'name': 'Le Minerale Cawang',
        'address': 'Jl. Mawar Raya No. 45',
        'distance': '3 Km',
        'rating': '4.7',
      },
      {
        'name': 'Aqua Cipinang',
        'address': 'Jl. Melati Indah No. 12',
        'distance': '4 Km',
        'rating': '4.6',
      },
    ];

    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: stores.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => _storeCard(stores[index]),
      ),
    );
  }

  Widget _storeCard(Map<String, String> store) {
    return Container(
      width: 220.w,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Container(
                  height: 100.h,
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
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 56.h,
                    color: primaryColor,
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, size: 12.h, color: primaryColor),
                      SizedBox(width: 2.w),
                      Text(
                        store['distance']!,
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store['name']!,
                  style: primaryTextStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  store['address']!,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11.sp,
                    fontWeight: regular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.h,
                      color: Color(0xffFFC107),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      store['rating']!,
                      style: primaryTextStyle.copyWith(
                        fontSize: 11.sp,
                        fontWeight: semiBold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(6.h),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14.h,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container tutorial(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _tutorialItem(
              icon: Icon(Icons.location_on, size: 22.h, color: primaryColor),
              label: AppLocalizations.of(context)!.pickLocation,
            ),
          ),
          Container(height: 60.h, width: 1.w, color: backgroundColor3),
          Expanded(
            child: _tutorialItem(
              icon: Image.asset(
                'assets/images/mesingalon.png',
                height: 22.h,
                width: 22.w,
              ),
              label: AppLocalizations.of(context)!.pickMesin,
            ),
          ),
          Container(height: 60.h, width: 1.w, color: backgroundColor3),
          Expanded(
            child: _tutorialItem(
              icon: Icon(Icons.credit_card, size: 22.h, color: primaryColor),
              label: AppLocalizations.of(context)!.payment,
            ),
          ),
          Container(height: 60.h, width: 1.w, color: backgroundColor3),
          Expanded(
            child: _tutorialItem(
              icon: Image.asset(
                'assets/images/galon.png',
                height: 22.h,
                width: 22.w,
              ),
              label: AppLocalizations.of(context)!.fillUp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tutorialItem({required Widget icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: icon,
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: primaryTextStyle.copyWith(fontSize: 11.sp, fontWeight: medium),
        ),
      ],
    );
  }

  Container headline(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 12.w, top: 12.h, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.headlineOne,
                    style: primaryTextStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: extraBold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.headlineTwo,
                    style: headingBlueTextStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: extraBold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(context)!.subHeadline,
                    style: primaryTextStyle.copyWith(
                      fontSize: 12.sp,
                      fontWeight: regular,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 36.h,
                    width: 140.w,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/main',
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.checkOut,
                            style: headingTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: whiteColor,
                            size: 14.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 190.h,
              width: double.infinity,
              child: Image.asset(
                'assets/images/galonHeadline.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container header(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.dashboardGreeting}, Budi!',
                  style: primaryTextStyle.copyWith(
                    fontSize: 24.sp,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppLocalizations.of(context)!.dashboardSub,
                  style: primaryTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: regular,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: Icon(
              Icons.notifications,
              color: primaryTextColor,
              size: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
