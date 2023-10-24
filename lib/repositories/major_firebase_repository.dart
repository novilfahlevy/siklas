import 'package:siklas/models/major_model.dart';
import 'package:siklas/repositories/interfaces/major_repository_interface.dart';
import 'package:siklas/services/major_firebase_service.dart';

class MajorFirebaseRepository implements MajorRepositoryInterface {
  @override
  Future<List<MajorModel>> all() async {
    final MajorFirebaseService service = MajorFirebaseService();
    final majorDocs = await service.getMajors();

    if (majorDocs.isNotEmpty) {
      return majorDocs
        .toList()
        .map((final majorDoc) => MajorModel(id: majorDoc.id, name: majorDoc.get('name')))
        .toList();
    }

    return [];
  }
}