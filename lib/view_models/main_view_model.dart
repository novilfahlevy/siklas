import 'package:flutter/material.dart';
import 'package:siklas/screens/borrowings_screen.dart';
import 'package:siklas/screens/classes_screen.dart';

class MainViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _screens = [
    { 'title': 'Kelas', 'screen': const ClassesScreen() },
    { 'title': 'Peminjaman', 'screen': const BorrowingsScreen() },
  ];

  int _selectedScreenIndex = 0;

  void setSelectedScreenIndex(int index) {
    _selectedScreenIndex = index;
    notifyListeners();
  }

  int getSelectedScreenIndex() {
    return _selectedScreenIndex;
  }

  String getCurrentScreenTitle() {
    return _screens[_selectedScreenIndex]['title'];
  }

  Widget getCurrentScreen() {
    return _screens[_selectedScreenIndex]['screen'];
  }
}