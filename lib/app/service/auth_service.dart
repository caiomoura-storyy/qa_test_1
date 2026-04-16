import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStage {
  loggedOut,
  pendingTwoFactor,
  authenticated,
  lockedOut,
}

class AuthService extends ChangeNotifier {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const _validEmail = 'admin';
  static const _validPassword = 'admin';
  static const _validTwoFactor = '12345';
  static const _maxLoginAttempts = 3;
  static const _storageKey = 'auth.authenticated';

  AuthStage _stage = AuthStage.loggedOut;
  int _failedLoginAttempts = 0;
  bool _initialized = false;

  AuthStage get stage => _stage;
  bool get isAuthenticated => _stage == AuthStage.authenticated;
  bool get isLockedOut => _stage == AuthStage.lockedOut;
  bool get isInitialized => _initialized;
  int get remainingAttempts => _maxLoginAttempts - _failedLoginAttempts;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_storageKey) ?? false) {
      _stage = AuthStage.authenticated;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (_stage == AuthStage.lockedOut) return false;

    final valid = email == _validEmail && password == _validPassword;
    if (valid) {
      _stage = AuthStage.pendingTwoFactor;
      notifyListeners();
      return true;
    }

    _failedLoginAttempts++;
    if (_failedLoginAttempts >= _maxLoginAttempts) {
      _stage = AuthStage.lockedOut;
    }
    notifyListeners();
    return false;
  }

  Future<bool> verifyTwoFactor(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (_stage != AuthStage.pendingTwoFactor) return false;

    if (code == _validTwoFactor) {
      _stage = AuthStage.authenticated;
      _failedLoginAttempts = 0;
      await _persist(true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> reset() async {
    _stage = AuthStage.loggedOut;
    _failedLoginAttempts = 0;
    await _persist(false);
    notifyListeners();
  }

  Future<void> logout() => reset();

  Future<void> _persist(bool authenticated) async {
    final prefs = await SharedPreferences.getInstance();
    if (authenticated) {
      await prefs.setBool(_storageKey, true);
    } else {
      await prefs.remove(_storageKey);
    }
  }
}
