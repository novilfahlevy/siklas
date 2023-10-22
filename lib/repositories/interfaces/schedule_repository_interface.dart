import 'package:siklas/models/schedule_model.dart';

abstract class ScheduleRepositoryInterface {
  Future<List<ScheduleModel>> getSchedules(String classId);
}