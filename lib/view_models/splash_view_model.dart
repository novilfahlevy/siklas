import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends ChangeNotifier {
  Future<String?> checkIsUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null && userId != '') {
      return userId;
    }

    return null;
  }
}