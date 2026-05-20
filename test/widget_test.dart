// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:galonku/main.dart';

void main() {
  testWidgets('App smoke test - splash page and sign in navigation', (WidgetTester tester) async {
    // Set screen size to simulate a mobile device and prevent ScreenUtil layout overflows
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    
    // Reset view properties after the test finishes
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that SplashPage is loaded and shows 'GalonKu'.
    expect(find.text('GalonKu'), findsOneWidget);
    expect(find.text('Isi Galon Jadi Lebih Mudah'), findsOneWidget);

    // Wait for the splash screen timer (1 second) and trigger navigation.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify that we are navigated to the SignInPage.
    // The SignInPage uses localization, but since it's inside MyApp,
    // the localizations are correctly provided.
    // Let's verify that the email input/label or some login-specific elements are present.
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}

