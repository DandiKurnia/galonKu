import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galonku/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

// exp: 9999999999 — token "baru" yang masih lama berlaku.
const _freshAccess =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImV4cCI6OTk5OTk5OTk5OX0.sig';

void main() {
  setUp(() {
    dotenv.testLoad(fileInput: 'APP_BACKEND=https://api.test');
    SharedPreferences.setMockInitialValues({
      'access_token': 'old-expired-access',
      'refresh_token': 'old-refresh',
    });
  });

  test('refreshTokens rotates and persists both new tokens', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/auth/refresh');
      // Backend memakai camelCase untuk body refresh.
      expect(jsonDecode(request.body)['refreshToken'], 'old-refresh');
      return http.Response(
        jsonEncode({
          'access_token': _freshAccess,
          'refresh_token': 'new-refresh',
        }),
        200,
      );
    });
    final service = AuthService(client: client);

    final returned = await service.refreshTokens();

    expect(returned, _freshAccess);
    expect(await service.getToken(), _freshAccess);
    // Refresh token lama wajib tergantikan yang baru (backend me-rotasi).
    expect(await service.getRefreshToken(), 'new-refresh');
  });

  test('concurrent refreshTokens trigger only one network call (single-flight)',
      () async {
    var calls = 0;
    final client = MockClient((request) async {
      calls++;
      return http.Response(
        jsonEncode({
          'access_token': _freshAccess,
          'refresh_token': 'new-refresh',
        }),
        200,
      );
    });
    final service = AuthService(client: client);

    final results = await Future.wait([
      service.refreshTokens(),
      service.refreshTokens(),
      service.refreshTokens(),
    ]);

    // Kunci anti-reuse: refresh token lama hanya dikirim sekali walau dipanggil
    // paralel, sehingga backend tidak menganggapnya token reuse.
    expect(calls, 1);
    expect(results, everyElement(_freshAccess));
  });

  test('refreshTokens clears session and throws on 401', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({'message': 'Token reuse detected. All sessions revoked.'}),
        401,
      );
    });
    final service = AuthService(client: client);

    await expectLater(
      service.refreshTokens(),
      throwsA(isA<SessionExpiredException>()),
    );
    expect(await service.getToken(), isNull);
    expect(await service.getRefreshToken(), isNull);
  });

  test('getValidToken throws when no token stored', () async {
    SharedPreferences.setMockInitialValues({});
    final service = AuthService(client: MockClient((_) async {
      return http.Response('', 200);
    }));

    await expectLater(
      service.getValidToken(),
      throwsA(isA<SessionExpiredException>()),
    );
  });
}
