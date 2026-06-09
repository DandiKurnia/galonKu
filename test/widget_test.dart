import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galonku/models/auth_model.dart';
import 'package:galonku/pages/splash_page.dart';
import 'package:galonku/providers/auth_provider.dart';
import 'package:galonku/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  test('bootstrap marks unauthenticated when saved token is expired', () async {
    final auth = AuthProvider(
      authService: FakeAuthService(token: _expiredToken, user: _fakeUser),
    );

    await auth.bootstrap();

    expect(auth.status, AuthStatus.unauthenticated);
    expect(auth.isAuthenticated, isFalse);
    expect(auth.user, isNull);
    expect(auth.token, isNull);
  });

  test('bootstrap recovers session when refresh token is still valid', () async {
    final auth = AuthProvider(
      authService: FakeAuthService(
        token: _expiredToken,
        user: _fakeUser,
        refreshToken: _validToken,
      ),
    );

    await auth.bootstrap();

    expect(auth.status, AuthStatus.authenticated);
    expect(auth.isAuthenticated, isTrue);
    expect(auth.user, isNotNull);
    // Access token expired ditukar dengan token baru hasil refresh.
    expect(auth.token, _validToken);
  });

  testWidgets('splash redirects to sign-in when saved token is expired', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(
          authService: FakeAuthService(token: _expiredToken, user: _fakeUser),
        ),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) {
            return MaterialApp(
              initialRoute: '/',
              routes: {
                '/': (_) => const SplashPage(),
                '/sign-in': (_) => const Scaffold(body: Text('sign-in-page')),
                '/main': (_) => const Scaffold(body: Text('main-page')),
              },
            );
          },
        ),
      ),
    );

    expect(find.text('GalonKu'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('sign-in-page'), findsOneWidget);
    expect(find.text('main-page'), findsNothing);
  });
}

class FakeAuthService extends AuthService {
  FakeAuthService({this.token, this.user, this.refreshToken});

  final String? token;
  final User? user;
  final String? refreshToken;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<String?> getRefreshToken() async => refreshToken;

  @override
  Future<User?> getUser() async => user;

  @override
  Future<String> refreshTokens() async {
    final rt = refreshToken;
    if (rt == null || rt.isEmpty) {
      throw SessionExpiredException();
    }
    return rt;
  }

  @override
  Future<void> clearSession() async {}
}

const _expiredToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImV4cCI6MX0.signature';

// exp: 9999999999 (jauh di masa depan). Dipakai sebagai hasil refresh token
// pada FakeAuthService — bootstrap menerimanya apa adanya tanpa validasi ulang.
const _validToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImV4cCI6OTk5OTk5OTk5OX0.signature';

final _fakeUser = User(
  id: 1,
  roleId: 1,
  name: 'Super Admin',
  email: 'superadmin@mail.com',
  avatar: null,
  phoneNumber: '0811111111',
  addressId: null,
  createdAt: DateTime.parse('2026-04-19T09:32:27.839Z'),
  updatedAt: DateTime.parse('2026-04-19T09:32:27.839Z'),
  role: Role(
    id: 1,
    name: 'Super Admin',
    key: 'super-admin',
    createdAt: DateTime.parse('2026-04-19T09:32:27.385Z'),
    updatedAt: DateTime.parse('2026-04-19T09:32:27.385Z'),
    rolePermissions: [],
    permissions: [],
  ),
);
