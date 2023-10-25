import 'package:siklas/models/major_model.dart';

abstract class MajorRepositoryInterface {
  Future<List<MajorModel>> all();

  Future<MajorModel?> getMajorById(String majorId);
}