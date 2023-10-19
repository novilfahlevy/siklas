import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialNameViewModel extends ChangeNotifier {
  String initialName = '';
  
  Future<void> getInitialName() async {
    final prefs = await SharedPreferences.getInstance();
    initialName = prefs.getString('userInitialName') ?? '-';
    notifyListeners();
  }
}