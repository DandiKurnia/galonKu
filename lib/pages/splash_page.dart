import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/sign-in');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(children: [logo(), fotter()]),
    );
  }

  Align fotter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Isi Galon Jadi Lebih Mudah',
              style: headingTextStyle.copyWith(
                fontSize: 16.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 120.w,
                height: 6.h,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(backgroundColor1),
                  backgroundColor: backgroundColor1.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center logo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/image_splash.png',
            height: 100.h,
            width: 100.w,
          ),
          SizedBox(height: 20.h),
          Text(
            'GalonKu',
            style: headingTextStyle.copyWith(fontSize: 24.sp, fontWeight: bold),
          ),
        ],
      ),
    );
  }
}
