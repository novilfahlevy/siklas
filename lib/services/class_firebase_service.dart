import 'package:cloud_firestore/cloud_firestore.dart';

class ClassFirebaseService {
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getClasses(String floorId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('classes')
        .where('floor_id', isEqualTo: FirebaseFirestore.instance.doc('floors/$floorId'))
        .get();
      
      return users.docs;
    } on Exception catch (_) {
      // TODO
      return [];
    }
  }
}