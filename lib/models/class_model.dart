import 'package:siklas/models/floor_model.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';

class ClassModel {
  String id;
  String floorId;
  String name;
  String imageFilename;

  ClassModel({
    required this.id,
    required this.name,
    required this.imageFilename,
    required this.floorId
  });

  Future<FloorModel?> getFloorModel() async {
    FloorFirebaseRepository repository = FloorFirebaseRepository();
    final floorModel = await repository.getFloorById(floorId);

    if (floorModel != null) return floorModel;

    return null;
  }
}