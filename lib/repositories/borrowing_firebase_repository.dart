import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';
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

        final userDocRef = borrowingDoc.get('user_id');
        final userDoc = await userDocRef.get();

        borrowings.add(BorrowingModel(
          id: borrowingDoc.id,
          classId: classDoc.id,
          majorId: majorDoc.id,
          userId: userDoc.id,
          title: borrowingDoc.get('title'),
          description: borrowingDoc.get('title'),
          status: borrowingDoc.get('status'),
          date: (borrowingDoc.get('date') as Timestamp).toDate(),
          timeFrom: TimeOfDay.fromDateTime((borrowingDoc.get('time_from') as Timestamp).toDate()),
          timeUntil: TimeOfDay.fromDateTime((borrowingDoc.get('time_until') as Timestamp).toDate())
        ));
      }

      return borrowings;
    }

    return [];
  }

  @override
  Future<BorrowingModel?> createBorrowing({
    required String classId,
    required String majorId,
    required String userId,
    required String title,
    required String description,
    required int status,
    required DateTime date,
    required TimeOfDay timeFrom,
    required TimeOfDay timeUntil,
    String? staffId,
    String? rejectedMessage
  }) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    final borrowing = await service.createBorrowing(
      classId: classId,
      majorId: majorId,
      userId: userId,
      staffId: staffId,
      title: title,
      description: description,
      status: status,
      date: date,
      timeFrom: timeFrom,
      timeUntil: timeUntil
    );

    final classDoc = await borrowing?['class_id'].get();
    final majorDoc = await borrowing?['major_id'].get();
    final userDoc = await borrowing?['user_id'].get();

    if (borrowing != null) {
      return BorrowingModel(
        id: borrowing['id'],
        classId: classDoc.id,
        majorId: majorDoc.id,
        userId: userDoc.id,
        title: borrowing['title'],
        description: borrowing['description'],
        status: borrowing['status'],
        date: borrowing['date'],
        timeFrom: borrowing['time_from'],
        timeUntil: borrowing['time_until'],
        rejectedMessage: borrowing['rejected_message']
      );
    }

    return null;
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