import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ScheduleFirebaseService {
  Future<List<QueryDocumentSnapshot>> getSchedules(String classId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('regular_schedules')
        .where('class_id', isEqualTo: FirebaseFirestore.instance.doc('classes/$classId'))
        .get();
      
      return users.docs;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}