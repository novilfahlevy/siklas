import 'package:cloud_firestore/cloud_firestore.dart';

class FloorFirebaseService {
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFloors() async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('floors')
        .orderBy('name')
        .get();
      
      return users.docs;
    } on Exception catch (_) {
      // TODO
      return [];
    }
  }
}