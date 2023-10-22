import 'package:flutter/material.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/models/schedule_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/class_firebase_repository.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';
import 'package:siklas/screens/class_borrowings_screen.dart';
import 'package:siklas/screens/schedule_screen.dart';

class ClassViewModel extends ChangeNotifier {
  ClassModel? _class;

  ClassModel? get classModel => _class;

  FloorModel? _floor;

  FloorModel? get floorModel => _floor;

  final List<Widget> _screens = [
    const ScheduleScreen(),
    const ClassBorrowingsScreen()
  ];

  int _selectedScreenIndex = 0;

  Widget get currentScreen => _screens[_selectedScreenIndex];

  int get selectedScreenIndex => _selectedScreenIndex;

  set selectedScreenIndex(int index) {
    _selectedScreenIndex = index;
    notifyListeners();
  }

  bool _isFetchingClass = true;

  bool get isFetchingClass => _isFetchingClass;

  set isFetchingClass(bool isFetching) {
    _isFetchingClass = isFetching;
    notifyListeners();
  }

  bool _isClassFetched = false;

  bool get isClassFetched => _isClassFetched;

  set isClassFetched(bool isFetched) {
    _isClassFetched = isFetched;
    notifyListeners();
  }

  Future<void> fetchClass(String classId) async {
    selectedScreenIndex = 0;

    isClassFetched = false;
    isFetchingClass = true;

    try {
      final ClassFirebaseRepository classRepository = ClassFirebaseRepository();
      _class = await classRepository.getClass(classId);
      
      final FloorFirebaseRepository floorRepository = FloorFirebaseRepository();
      _floor = await floorRepository.getFloor(_class!.floorId);
    } on Exception catch (_) {
      // TODO
    } finally {
      isClassFetched = true;
      isFetchingClass = false;
    }
  }
}