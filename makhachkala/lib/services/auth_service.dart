import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = true; // Mock: assume user is logged in
  String? _userId;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;

  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic
    _isAuthenticated = true;
    _userId = 'user_123';
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}

