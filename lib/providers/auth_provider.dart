import 'package:flutter/foundation.dart';
import 'package:galonku/models/auth_model.dart';
import 'package:galonku/services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  String? _token;
  bool _loading = false;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get token => _token;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> bootstrap() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      _status = AuthStatus.unauthenticated;
      _user = null;
      _token = null;
      notifyListeners();
      return;
    }

    _token = token;
    _user = await _authService.getUser();
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signIn(email, password);
      await _authService.saveSession(result);
      _user = result.user;
      _token = result.accessToken;
      _status = AuthStatus.authenticated;
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUp(name, email, password);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.clearSession();
    _user = null;
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }
}
