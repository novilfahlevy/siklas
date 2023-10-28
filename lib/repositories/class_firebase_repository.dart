import 'package:siklas/models/class_model.dart';
import 'package:siklas/repositories/interfaces/class_repository_interface.dart';
import 'package:siklas/services/class_firebase_service.dart';

class ClassFirebaseRepository implements ClassRepositoryInterface {
  @override
  Future<List<ClassModel>> getClassesByFloorId(String floorId) async {
    final ClassFirebaseService service = ClassFirebaseService();
    final classDocs = await service.getClassesByFloorId(floorId);

    if (classDocs.isNotEmpty) {
      return classDocs
        .toList()
        .map((final classDoc) {
          final images = classDoc.get('image_name') as List<dynamic>;
          
          return ClassModel(
            id: classDoc.id,
            name: classDoc.get('name'),
            imageFilename: images
              .map((imageName) => imageName.toString())
              .toList(),
            floorId: floorId,
          );
        })
        .toList();
    }

    return [];
  }

  @override
  Future<ClassModel?> getClassById(String classId) async {
    final ClassFirebaseService service = ClassFirebaseService();
    final classDoc = await service.getClassById(classId);

    if (classDoc != null) {
      final floorDocRef = classDoc.get('floor_id');
      final floorDoc = await floorDocRef.get();

      final images = classDoc.get('image_name') as List<dynamic>;

      return ClassModel(
        id: classDoc.id,
        name: classDoc.get('name'),
        imageFilename: images
        .map((imageName) => imageName.toString())
          .toList(),
        floorId: floorDoc.id,
      );
    }

    return null;
  }
}