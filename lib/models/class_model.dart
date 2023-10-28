import 'package:siklas/models/floor_model.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClassModel {
  String id;
  String floorId;
  String name;
  List<String> imageFilename;

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

  Future<String> getImagePath({ int index = 0 }) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(imageFilename[index]);
    final downloadUrl = await imageRef.getDownloadURL();

    return downloadUrl;
  }
}