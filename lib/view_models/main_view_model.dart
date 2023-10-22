import 'package:flutter/material.dart';
import 'package:siklas/screens/user_borrowings_screen.dart';
import 'package:siklas/screens/classes_screen.dart';

class MainViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _screens = [
    { 'title': 'Kelas', 'screen': const ClassesScreen() },
    { 'title': 'Peminjaman', 'screen': const UserBorrowingsScreen() },
  ];

  int _selectedScreenIndex = 0;

  bool _isScreenEverChanged = false;
  
  bool get isScreenEverChanged => _isScreenEverChanged;

  void setSelectedScreenIndex(int index) {
    _selectedScreenIndex = index;
    _isScreenEverChanged = true;
    notifyListeners();
  }

  int get selectedScreenIndex => _selectedScreenIndex;

  String get currentScreenTitle => _screens[_selectedScreenIndex]['title'];

  Widget get currentScreen => _screens[_selectedScreenIndex]['screen'];
}