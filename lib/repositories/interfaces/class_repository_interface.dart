import 'package:siklas/models/class_model.dart';

abstract class ClassRepositoryInterface {
  Future<List<ClassModel>> getClasses(String floorId);
}