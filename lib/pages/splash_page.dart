import 'dart:async';

import 'package:flutter/material.dart';
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
        margin: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Isi Galon Jadi Lebih Mudah',
              style: headingTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 120,
                height: 6,
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
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 20),
          Text(
            'GalonKu',
            style: headingTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
        ],
      ),
    );
  }
}
