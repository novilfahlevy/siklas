import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BorrowingFirebaseService {
  Future<List<QueryDocumentSnapshot>> getBorrowingsByClassId(String classId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('borrowings')
        .orderBy('date')
        .where('class_id', isEqualTo: FirebaseFirestore.instance.doc('classes/$classId'))
        .where('status', isEqualTo: 2)
        .get();
      
      return users.docs;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}