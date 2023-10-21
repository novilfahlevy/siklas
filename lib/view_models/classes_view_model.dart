import 'package:flutter/material.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/repositories/class_firebase_repository.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';

class ClassesViewModel extends ChangeNotifier {
  List<FloorModel> _floors = [];

  List<FloorModel> get floors => _floors;

  FloorModel? _selectedFloor;

  set selectedFloor(FloorModel? floor) {
    _selectedFloor = floor;
    fetchClasses();
  }

  FloorModel? get firstFloor => floors.isNotEmpty ? floors.first : null;

  List<ClassModel> _classes = [];
  
  List<ClassModel> get classes => _classes;

  bool _isFetchingClasses = true;

  bool get isFetchingClasses => _isFetchingClasses;

  set isFetchingClasses(bool isFetching) {
    _isFetchingClasses = isFetching;
    notifyListeners();
  }

  Future<void> fetchFloors() async {
    final FloorFirebaseRepository repository = FloorFirebaseRepository();
    _floors = await repository.all();

    selectedFloor = firstFloor;
  }

  Future<void> fetchClasses() async {
    if (_selectedFloor != null) {
      isFetchingClasses = true;

      final ClassFirebaseRepository repository = ClassFirebaseRepository();
      _classes = await repository.getClasses(_selectedFloor!.id);
      
      isFetchingClasses = false;
    }
  }
}