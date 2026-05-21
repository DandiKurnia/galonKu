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
  @override
  Widget build(BuildContext context) {
    return ListView(
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
      ],
    );
  }

  Container locationStore() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 30.h,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aqua Jakarta Timur',
                            style: primaryTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Jl. Pendidikan No. 123 312312 3123123',
                            style: secondaryTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        'Jarak 2 Km',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.h,
                      color: secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            height: 1.w,
            width: double.infinity,
            color: backgroundColor3,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 30.h,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aqua Jakarta Timur',
                            style: primaryTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Jl. Pendidikan No. 123 312312 3123123',
                            style: secondaryTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        'Jarak 2 Km',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.h,
                      color: secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            height: 1.w,
            width: double.infinity,
            color: backgroundColor3,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 30.h,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aqua Jakarta Timur',
                            style: primaryTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Jl. Pendidikan No. 123 312312 3123123',
                            style: secondaryTextStyle.copyWith(
                              fontSize: 12.sp,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        'Jarak 2 Km',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.h,
                      color: secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            height: 1.w,
            width: double.infinity,
            color: backgroundColor3,
          ),
          SizedBox(height: 8.h),
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
                        Navigator.pushNamed(context, '/main');
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
