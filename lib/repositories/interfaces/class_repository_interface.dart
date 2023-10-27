import 'package:siklas/models/class_model.dart';

abstract class ClassRepositoryInterface {
  Future<ClassModel?> getClassById(String classId);

  Future<List<ClassModel>> getClassesByFloorId(String floorId);
}