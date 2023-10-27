import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siklas/models/user_model.dart';

class SplashViewModel extends ChangeNotifier {
  Future<UserModel?> checkIsUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    String? authId = prefs.getString('authId');
    String? userId = prefs.getString('userId');
    String? userName = prefs.getString('userName');
    String? userRole = prefs.getString('userRole');
    
    if (authId != null && userId != null && userName != null && userRole != null) {
      return UserModel(id: userId, authId: authId, name: userName, role: userRole);
    }

    return null;
  }
}