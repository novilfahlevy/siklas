import 'package:cloud_firestore/cloud_firestore.dart';

class MajorFirebaseService {
  Future<List<QueryDocumentSnapshot>> getMajors() async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final majorColRef = await db.collection('majors')
        .orderBy('name')
        .get();
      
      return majorColRef.docs;
    } on Exception catch (_) {
      // TODO
      return [];
    }
  }
}