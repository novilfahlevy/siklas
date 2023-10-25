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

    if (prefs.getString('userId') != null || prefs.getString('userId') != '') {
      await prefs.remove('userId');

      isLoggingOut = false;
      return true;
    }

    isLoggingOut = false;
    return false;
  }
}