import 'package:cloud_firestore/cloud_firestore.dart';

class FloorFirebaseService {
  Future<List<QueryDocumentSnapshot>> getFloors() async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final floorColRef = await db.collection('floors')
        .orderBy('name')
        .get();
      
      return floorColRef.docs;
    } on Exception catch (_) {
      // TODO
      return [];
    }
  }

  Future<DocumentSnapshot?> getFloor(String floorId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final floorDocRef = await db.collection('floors').doc(floorId);
      final floorDoc = await floorDocRef.get();
      
      return floorDoc;
    } on Exception catch (_) {
      // TODO
      return null;
    }
  }
}