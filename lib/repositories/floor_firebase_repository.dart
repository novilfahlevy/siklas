import 'package:siklas/models/floor_model.dart';
import 'package:siklas/repositories/interfaces/floor_repository_interface.dart';
import 'package:siklas/services/floor_firebase_service.dart';

class FloorFirebaseRepository implements FloorRepositoryInterface {
  @override
  Future<List<FloorModel>> all() async {
    final FloorFirebaseService service = FloorFirebaseService();
    final floorDocs = await service.getFloors();

    if (floorDocs.isNotEmpty) {
      return floorDocs
        .toList()
        .map((final floorDoc) => FloorModel(floorDoc.id, floorDoc.get('name')))
        .toList();
    }

    return [];
  }
}