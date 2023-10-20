import 'package:siklas/models/floor_model.dart';

abstract class FloorRepositoryInterface {
  Future<List<FloorModel>> all();
}