import 'package:flutter/material.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/repositories/class_firebase_repository.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';
import 'package:siklas/screens/borrowings_screen.dart';
import 'package:siklas/screens/schedules_screen.dart';

class ClassViewModel extends ChangeNotifier {
  ClassModel? _class;

  ClassModel? get classModel => _class;

  FloorModel? _floor;

  FloorModel? get floorModel => _floor;

  final List<Widget> _screens = [
    const SchedulesScreen(),
    const BorrowingsScreen()
  ];

  int _selectedScreenIndex = 0;

  int get selectedScreenIndex => _selectedScreenIndex;

  set selectedScreenIndex(int index) {
    _selectedScreenIndex = index;
    notifyListeners();
  }

  Widget get currentScreen => _screens[_selectedScreenIndex];

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
      _class = await classRepository.getClassById(classId);

      if (_class != null) {
        final FloorFirebaseRepository floorRepository = FloorFirebaseRepository();
        _floor = await floorRepository.getFloorById(_class!.floorId);

        isClassFetched = true;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      isFetchingClass = false;
    }
  }
}