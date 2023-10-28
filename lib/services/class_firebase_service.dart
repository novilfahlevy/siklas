import 'package:cloud_firestore/cloud_firestore.dart';

class ClassFirebaseService {
  Future<List<QueryDocumentSnapshot>> getClassesByFloorId(String floorId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('classes')
        .where('floor_id', isEqualTo: FirebaseFirestore.instance.doc('floors/$floorId'))
        .orderBy('name')
        .get();
      
      return users.docs;
    } on Exception catch (_) {
      // TODO
      return [];
    }
  }

  Future<DocumentSnapshot?> getClassById(String classId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final userDocRef = db.collection('classes').doc(classId);
      final userDoc = await userDocRef.get();
      
      return userDoc;
    } on Exception catch (_) {
      // TODO
      return null;
    }
  }
}