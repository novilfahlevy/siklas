import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/schedule_model.dart';
import 'package:intl/intl.dart';
import 'package:siklas/repositories/interfaces/borrowing_repository_interface.dart';
import 'package:siklas/services/borrowing_firebase_service.dart';

class BorrowingFirebaseRepository implements BorrowingRepositoryInterface {
  @override
  Future<List<BorrowingModel>> getBorrowingsByClassId(String classId) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    final borrowingDocs = await service.getBorrowingsByClassId(classId);

    if (borrowingDocs.isNotEmpty) {
      List<BorrowingModel> borrowings = [];

      for (final borrowingDoc in borrowingDocs.toList()) {
        final classDocRef = borrowingDoc.get('class_id');
        final classDoc = await classDocRef.get();

        final majorDocRef = borrowingDoc.get('major_id');
        final majorDoc = await majorDocRef.get();

        final staffDocRef = borrowingDoc.get('staff_id');
        final staffDoc = await staffDocRef.get();

        final userDocRef = borrowingDoc.get('user_id');
        final userDoc = await userDocRef.get();

        borrowings.add(BorrowingModel(
          id: borrowingDoc.id,
          classId: classDoc.id,
          majorId: majorDoc.id,
          staffId: staffDoc.id,
          userId: userDoc.id,
          title: borrowingDoc.get('title'),
          description: borrowingDoc.get('title'),
          status: borrowingDoc.get('status'),
          date: convertDatetimeToDate(convertTimestampToDateTime(borrowingDoc.get('date'))),
          timeFrom: convertDatetimeToTime(convertTimestampToDateTime(borrowingDoc.get('time_from'))),
          timeUntil: convertDatetimeToTime(convertTimestampToDateTime(borrowingDoc.get('time_until'))),
          rejectedMessage: borrowingDoc.get('rejected_message'),
        ));
      }

      return borrowings;
    }

    return [];
  }

  DateTime convertTimestampToDateTime(dynamic timestamp) {
    return (timestamp as Timestamp).toDate();
  }

  String convertDatetimeToDate(DateTime date) {
    return DateFormat('d MMMM y').format(date);
  }

  String convertDatetimeToTime(DateTime date) {
    return DateFormat('Hm').format(date);
  }
}