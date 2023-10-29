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
        'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day, 0, 0, 0)),
        'time_from': Timestamp.fromDate(DateTime(date.year, date.month, date.day, timeFrom.hour, timeFrom.minute)),
        'time_until': Timestamp.fromDate(DateTime(date.year, date.month, date.day, timeUntil.hour, timeUntil.minute)),
        'created_at': now,
        'rejected_message': rejectedMessage ?? ''
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

  Future<QueryDocumentSnapshot?> checkIfBorrowingTimeHasBooked({
    required String classId,
    required DateTime date,
    required TimeOfDay timeFrom,
    required TimeOfDay timeUntil
  }) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;

      final newBorrowingTimeFrom = DateTime(date.year, date.month, date.day, timeFrom.hour, timeFrom.minute);
      final newBorrowingTimeUntil = DateTime(date.year, date.month, date.day, timeUntil.hour, timeUntil.minute);

      final classDocRef = FirebaseFirestore.instance.doc('classes/$classId');

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final borrowings = await db.collection('borrowings')
        .where('class_id', isEqualTo: classDocRef)
        .where('status', isEqualTo: 2)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

      for (final doc in borrowings.docs) {
        final existedBorrowingTimeFrom = (doc.get('time_from') as Timestamp).toDate();
        final existedBorrowingTimeUntil = (doc.get('time_until') as Timestamp).toDate();

        if (
          newBorrowingTimeFrom.isAtSameMomentAs(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isBefore(existedBorrowingTimeUntil)
        ) {
          return doc;
        }

        if (
          newBorrowingTimeFrom.isAtSameMomentAs(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isAtSameMomentAs(existedBorrowingTimeUntil)
        ) {
          return doc;
        }
        
        if (
          newBorrowingTimeFrom.isAtSameMomentAs(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isAfter(existedBorrowingTimeUntil)
        ) {
          return doc;
        }

        if (
          newBorrowingTimeFrom.isBefore(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isAfter(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isBefore(existedBorrowingTimeUntil)
        ) {
          return doc;
        }
        
        if (
          newBorrowingTimeFrom.isBefore(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isAtSameMomentAs(existedBorrowingTimeUntil)
        ) {
          return doc;
        }

        if (
          newBorrowingTimeFrom.isBefore(existedBorrowingTimeFrom) &&
          newBorrowingTimeUntil.isAfter(existedBorrowingTimeUntil)
        ) {
          return doc;
        }

        if (
          newBorrowingTimeFrom.isAfter(existedBorrowingTimeFrom) &&
          newBorrowingTimeFrom.isBefore(existedBorrowingTimeUntil) &&
          newBorrowingTimeUntil.isAfter(existedBorrowingTimeUntil)
        ) {
          return doc;
        }
      }
      
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> checkIfBorrowingTimeIsSameAsClassSchedule({
    required String classId,
    required DateTime date,
    required TimeOfDay timeFrom,
    required TimeOfDay timeUntil
  }) async {
    // TODO: Check if the time is same as the class regular schedules
    // try {
    //   final FirebaseFirestore db = FirebaseFirestore.instance;

    //   final newBorrowingTimeFrom = DateTime(date.year, date.month, date.day, timeFrom.hour, timeFrom.minute);
    //   final newBorrowingTimeUntil = DateTime(date.year, date.month, date.day, timeUntil.hour, timeUntil.minute);

    //   final classDocRef = FirebaseFirestore.instance.doc('classes/$classId');

    //   final schedules = await db.collection('regular_schedules')
    //     .where('class_id', isEqualTo: classDocRef)
    //     .get();

    //   for (final doc in schedules.docs) {
    //     final scheduleWeekday = (doc.get('day') as Timestamp).toDate().weekday;
        
    //     if (scheduleWeekday == date.weekday) {
    //       final scheduleTimeFrom = (doc.get('time_from') as Timestamp).toDate();
    //       final scheduleTimeUntil = (doc.get('time_until') as Timestamp).toDate();

    //       if (
    //         newBorrowingTimeFrom.isAtSameMomentAs(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isBefore(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }

    //       if (
    //         newBorrowingTimeFrom.isAtSameMomentAs(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isAtSameMomentAs(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }
          
    //       if (
    //         newBorrowingTimeFrom.isAtSameMomentAs(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isAfter(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }

    //       if (
    //         newBorrowingTimeFrom.isBefore(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isAfter(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isBefore(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }
          
    //       if (
    //         newBorrowingTimeFrom.isBefore(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isAtSameMomentAs(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }

    //       if (
    //         newBorrowingTimeFrom.isBefore(scheduleTimeFrom) &&
    //         newBorrowingTimeUntil.isAfter(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }

    //       if (
    //         newBorrowingTimeFrom.isAfter(scheduleTimeFrom) &&
    //         newBorrowingTimeFrom.isBefore(scheduleTimeUntil) &&
    //         newBorrowingTimeUntil.isAfter(scheduleTimeUntil)
    //       ) {
    //         return true;
    //       }
    //     }
    //   }
      
    //   return false;
    // } on Exception catch (e) {
    //   debugPrint(e.toString());
    //   return false;
    // }

    return false;
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

  Future<bool> acceptBorrowing({
    required String borrowingId,
    required String staffId,
  }) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      
      await db.collection('borrowings')
        .doc(borrowingId)
        .update({
          'status': 2,
          'staff_id': db.collection('users').doc(staffId)
        });
      
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> rejectBorrowing({
    required String borrowingId,
    required String staffId,
    required String message
  }) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      
      await db.collection('borrowings')
        .doc(borrowingId)
        .update({
          'rejected_message': message,
          'status': 1,
          'staff_id': db.collection('users').doc(staffId)
        });
      
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}