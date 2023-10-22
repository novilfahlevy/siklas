import 'package:flutter/material.dart';
import 'package:siklas/models/schedule_model.dart';
import 'package:siklas/repositories/schedule_firebase_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  List<ScheduleModel> _schedules = [];

  List<ScheduleModel> get schedules => _schedules;

  bool _isFetchingSchedules = false;

  bool get isFetchingSchedules => _isFetchingSchedules;

  set isFetchingSchedules(bool isFetching) {
    _isFetchingSchedules = isFetching;
    notifyListeners();
  }
  
  Future<void> fetchSchedules(String classId) async {
    isFetchingSchedules = true;
    _schedules = [];

    try {
      final repository = ScheduleFirebaseRepository();
      _schedules = await repository.getSchedules(classId);
    } on Exception catch (_) {
      // TODO
    } finally {
      isFetchingSchedules = false;
    }
  }
}