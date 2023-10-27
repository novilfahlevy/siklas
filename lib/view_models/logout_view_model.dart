import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutViewModel extends ChangeNotifier {
  bool _isLoggingOut = false;

  bool get isLoggingOut => _isLoggingOut;

  set isLoggingOut(bool isLoggingOut) {
    _isLoggingOut = isLoggingOut;
    notifyListeners();
  }

  Future<bool> logout() async {
    isLoggingOut = true;
    
    final prefs = await SharedPreferences.getInstance();

    String? authId = prefs.getString('authId');
    String? userId = prefs.getString('userId');
    String? userName = prefs.getString('userName');
    String? userRole = prefs.getString('userRole');

    if (authId != null && userId != null && userName != null && userRole != null) {
      await prefs.remove('authId');
      await prefs.remove('userId');
      await prefs.remove('userName');
      await prefs.remove('userRole');

      isLoggingOut = false;
      return true;
    }

    isLoggingOut = false;
    return false;
  }
}