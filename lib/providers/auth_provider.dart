import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _token;

  String? get userId => _userId;
  String? get token => _token;

  void setAuthData({required String userId, required String token}) {
    _userId = userId;
    _token = token;
    notifyListeners();
  }

  void clearAuthData() {
    _userId = null;
    _token = null;
    notifyListeners();
  }
}
