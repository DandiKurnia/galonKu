import 'package:flutter/material.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor1,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  nameInput(context),
                  const SizedBox(height: 20),
                  emailInput(context),
                  const SizedBox(height: 20),
                  passwordInput(context),
                  const SizedBox(height: 30),
                  const SignUpButton(),
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
      margin: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.haveAccount,
            style: primaryTextStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.login,
              style: headingBlueTextStyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox nameInput(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.name,
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  Icon(Icons.person, color: primaryColor, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context)!.name,
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

  SizedBox emailInput(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.email,
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  Icon(Icons.email, color: primaryColor, size: 24),
                  const SizedBox(width: 16),
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
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  Icon(Icons.lock, color: primaryColor, size: 24),
                  const SizedBox(width: 16),
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
                      size: 24,
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
      margin: const EdgeInsets.only(top: 100),
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
            child: Image.asset('assets/images/image_splash.png', width: 85),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.greeting,
            style: headingBlueTextStyle.copyWith(
              fontSize: 40,
              fontWeight: bold,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.subSignUp,
            style: secondaryTextStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
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
          AppLocalizations.of(context)!.signUp,
          style: headingTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}
