import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/config/theme.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentInvoicePage extends StatefulWidget {
  const PaymentInvoicePage({super.key});

  @override
  State<PaymentInvoicePage> createState() => _PaymentInvoicePageState();
}

class _PaymentInvoicePageState extends State<PaymentInvoicePage> {
  WebViewController? _controller;
  bool _hasInit = false;
  bool _loading = true;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInit) return;
    _hasInit = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! String || args.isEmpty) {
      setState(() {
        _loading = false;
        _errorMessage =
            AppLocalizations.of(context)!.invoiceLoadFailed;
      });
      return;
    }

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(whiteColor)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                if (!mounted) return;
                setState(() => _loading = true);
              },
              onPageFinished: (_) {
                if (!mounted) return;
                setState(() => _loading = false);
              },
              onWebResourceError: (error) {
                if (!mounted) return;
                setState(() {
                  _loading = false;
                  _errorMessage =
                      AppLocalizations.of(context)!.invoiceLoadFailed;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(args));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: whiteColor,
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
          l10n.invoiceAppbar,
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
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
      );
    }

    final controller = _controller;
    if (controller == null) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (_loading)
          Positioned.fill(
            child: ColoredBox(
              color: whiteColor.withValues(alpha: 0.6),
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
          ),
      ],
    );
  }
}
