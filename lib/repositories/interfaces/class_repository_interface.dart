import 'package:siklas/models/class_model.dart';

abstract class ClassRepositoryInterface {
  Future<List<ClassModel>> getClassesByFloorId(String floorId);

  Future<ClassModel?> getClassById(String classId);
}