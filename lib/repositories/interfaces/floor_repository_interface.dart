import 'package:siklas/models/floor_model.dart';

abstract class FloorRepositoryInterface {
  Future<List<FloorModel>> getFloors();

  Future<FloorModel?> getFloorById(String floorId);
}