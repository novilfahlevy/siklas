import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutViewModel extends ChangeNotifier {
  bool isLoggingOut = false;

  Future<bool> logout() async {
    isLoggingOut = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    bool isLogoutSucceed = false;

    if (prefs.getString('userId') != null || prefs.getString('userId') != '') {
      await prefs.remove('userId'); 
      isLogoutSucceed = true;
    }

    isLoggingOut = false;
    notifyListeners();

    return isLogoutSucceed;
  }
}