import 'package:siklas/models/major_model.dart';

abstract class MajorRepositoryInterface {
  Future<List<MajorModel>> getMajors();

  Future<MajorModel?> getMajorById(String majorId);
}