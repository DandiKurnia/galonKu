import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor1,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              margin: EdgeInsets.only(top: 30.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  emailInput(context),
                  SizedBox(height: 20.h),
                  passwordInput(context),
                  SizedBox(height: 30.h),
                  const SignInButton(),
                ],
              ),
            ),
            const Spacer(),
            footer(context),
          ],
        ),
      ),
    );
  }

  Container footer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.noAccount,
            style: primaryTextStyle.copyWith(fontSize: 12.sp),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/sign-up');
            },
            child: Text(
              AppLocalizations.of(context)!.register,
              style: headingBlueTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox emailInput(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.email,
            style: primaryTextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: medium,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.email, color: primaryColor, size: 24.h),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: TextField(
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context)!.email,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox passwordInput(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.password,
            style: primaryTextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: medium,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.lock, color: primaryColor, size: 24.h),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: TextField(
                      style: primaryTextStyle,
                      obscureText: _obscureText,
                      decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context)!.password,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: secondaryTextColor,
                      size: 24.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container header(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 80.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset('assets/images/image_splash.png', width: 85.w),
          ),
          SizedBox(height: 12.h),
          Text(
            AppLocalizations.of(context)!.greeting,
            style: headingBlueTextStyle.copyWith(
              fontSize: 36.sp,
              fontWeight: bold,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.subSignIn,
            style: secondaryTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/main');
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.signIn,
          style: headingTextStyle.copyWith(fontSize: 16.sp, fontWeight: medium),
        ),
      ),
    );
  }
}
