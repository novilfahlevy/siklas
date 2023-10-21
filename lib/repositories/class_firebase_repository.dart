import 'package:siklas/models/class_model.dart';
import 'package:siklas/repositories/interfaces/class_repository_interface.dart';
import 'package:siklas/services/class_firebase_service.dart';

class ClassFirebaseRepository implements ClassRepositoryInterface {
  @override
  Future<List<ClassModel>> getClasses(String floorId) async {
    final ClassFirebaseService service = ClassFirebaseService();
    final floorDocs = await service.getClasses(floorId);

    if (floorDocs.isNotEmpty) {
      return floorDocs
        .toList()
        .map((final classDoc) => ClassModel(
          id: classDoc.id,
          name: classDoc.get('name'),
          imageFilename: classDoc.get('image_name'),
          floorId: floorId,
        ))
        .toList();
    }

    return [];
  }
}