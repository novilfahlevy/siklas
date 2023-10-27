import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BorrowingFirebaseService {
  Future<DocumentSnapshot?> getBorrowingById(String borrowingId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      return await db.collection('borrowings').doc(borrowingId).get();
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getBorrowingsByClassId(String classId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final borrowings = await db.collection('borrowings')
        .where('class_id', isEqualTo: FirebaseFirestore.instance.doc('classes/$classId'))
        .where('status', isEqualTo: 2)
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('date')
        .orderBy('time_from')
        .get();
      
      return borrowings.docs;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<QueryDocumentSnapshot>> getBorrowingsByUserId(String userId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final borrowings = await db.collection('borrowings')
        .where('user_id', isEqualTo: FirebaseFirestore.instance.doc('users/$userId'))
        .orderBy('status')
        .orderBy('created_at')
        .get();
      
      return borrowings.docs;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<QueryDocumentSnapshot>> getNotYetRespondedBorrowings() async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final borrowings = await db.collection('borrowings')
        .orderBy('status')
        .orderBy('created_at')
        .get();
      
      return borrowings.docs;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> createBorrowing({
    required String classId,
    required String majorId,
    required String userId,
    required String? staffId,
    required String title,
    required String description,
    required int status,
    required DateTime date,
    required TimeOfDay timeFrom,
    required TimeOfDay timeUntil,
    String? rejectedMessage
  }) async {
    try {
      final classRef = FirebaseFirestore.instance.collection('classes').doc(classId);
      final majorRef = FirebaseFirestore.instance.collection('majors').doc(majorId);
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      final now = Timestamp.now();

      final borrowing = {
        'class_id': classRef,
        'major_id': majorRef,
        'user_id': userRef,
        'title': title,
        'description': description,
        'status': status,
        'date': Timestamp.fromDate(date),
        'time_from': Timestamp.fromDate(DateTime(date.year, date.month, date.day, timeFrom.hour, timeFrom.minute)),
        'time_until': Timestamp.fromDate(DateTime(date.year, date.month, date.day, timeUntil.hour, timeUntil.minute)),
        'created_at': now
      };

      final FirebaseFirestore db = FirebaseFirestore.instance;
      final borrowingDocRef = await db.collection('borrowings').add(borrowing);
      final borrowingDoc = await borrowingDocRef.get();

      borrowing['id'] = borrowingDoc.id;
      borrowing['date'] = date;
      borrowing['time_from'] = timeFrom;
      borrowing['time_until'] = timeUntil;
      borrowing['created_at'] = now.toDate();

      return borrowing;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> cancelBorrowingById(String borrowingId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      
      await db.collection('borrowings')
        .doc(borrowingId)
        .delete();
      
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}