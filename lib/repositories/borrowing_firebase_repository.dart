import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/repositories/interfaces/borrowing_repository_interface.dart';
import 'package:siklas/services/borrowing_firebase_service.dart';

class BorrowingFirebaseRepository implements BorrowingRepositoryInterface {
  @override
  Future<BorrowingModel?> getBorrowingById(String borrowingId) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    final borrowingDoc = await service.getBorrowingById(borrowingId);


    if (borrowingDoc != null && borrowingDoc.exists) {
      final borrowingMap = borrowingDoc.data() as Map<String, dynamic>;

      String classId = '';
      String majorId = '';
      String userId = '';
      String staffId = '';

      if (borrowingMap.containsKey('class_id')) {
        final classDocRef = borrowingDoc.get('class_id');
        final classDoc = await classDocRef.get();
        classId = classDoc.id;
      }

      if (borrowingMap.containsKey('major_id')) {
        final majorDocRef = borrowingDoc.get('major_id');
        final majorDoc = await majorDocRef.get();
        majorId = majorDoc.id;
      }

      if (borrowingMap.containsKey('user_id')) {
        final userDocRef = borrowingDoc.get('user_id');
        final userDoc = await userDocRef.get();
        userId = userDoc.id;
      }

      if (borrowingMap.containsKey('staff_id')) {
        final staffDocRef = borrowingDoc.get('staff_id');
        final staffDoc = await staffDocRef.get();
        staffId = staffDoc.id;
      }

      return BorrowingModel(
        id: borrowingDoc.id,
        classId: classId,
        majorId: majorId,
        userId: userId,
        staffId: staffId,
        title: borrowingDoc.get('title'),
        description: borrowingDoc.get('description'),
        status: borrowingDoc.get('status'),
        date: (borrowingDoc.get('date') as Timestamp).toDate(),
        timeFrom: TimeOfDay.fromDateTime((borrowingDoc.get('time_from') as Timestamp).toDate()),
        timeUntil: TimeOfDay.fromDateTime((borrowingDoc.get('time_until') as Timestamp).toDate()),
        createdAt: (borrowingDoc.get('created_at') as Timestamp).toDate(),
        rejectedMessage: borrowingDoc.get('rejected_message')
      );
    }

    return null;
  }

  @override
  Future<List<BorrowingModel>> getBorrowingsByClassId(String classId) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    final borrowingDocs = await service.getBorrowingsByClassId(classId);

    if (borrowingDocs.isNotEmpty) {
      List<BorrowingModel> borrowings = [];

      for (final borrowingDoc in borrowingDocs.toList()) {
        final borrowingMap = borrowingDoc.data() as Map<String, dynamic>;

        String classId = '';
        String majorId = '';
        String userId = '';
        String staffId = '';

        if (borrowingMap.containsKey('class_id')) {
          final classDocRef = borrowingDoc.get('class_id');
          final classDoc = await classDocRef.get();
          classId = classDoc.id;
        }

        if (borrowingMap.containsKey('major_id')) {
          final majorDocRef = borrowingDoc.get('major_id');
          final majorDoc = await majorDocRef.get();
          majorId = majorDoc.id;
        }

        if (borrowingMap.containsKey('user_id')) {
          final userDocRef = borrowingDoc.get('user_id');
          final userDoc = await userDocRef.get();
          userId = userDoc.id;
        }

        if (borrowingMap.containsKey('staff_id')) {
          final staffDocRef = borrowingDoc.get('staff_id');
          final staffDoc = await staffDocRef.get();
          staffId = staffDoc.id;
        }

        borrowings.add(BorrowingModel(
          id: borrowingDoc.id,
          classId: classId,
          majorId: majorId,
          userId: userId,
          staffId: staffId,
          title: borrowingDoc.get('title'),
          description: borrowingDoc.get('description'),
          status: borrowingDoc.get('status'),
          date: (borrowingDoc.get('date') as Timestamp).toDate(),
          timeFrom: TimeOfDay.fromDateTime((borrowingDoc.get('time_from') as Timestamp).toDate()),
          timeUntil: TimeOfDay.fromDateTime((borrowingDoc.get('time_until') as Timestamp).toDate()),
          createdAt: (borrowingDoc.get('created_at') as Timestamp).toDate(),
          rejectedMessage: borrowingDoc.get('rejected_message')
        ));
      }

      return borrowings;
    }

    return [];
  }

  @override
  Future<List<BorrowingModel>> getBorrowingsByUserId(String userId) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    final borrowingDocs = await service.getBorrowingsByUserId(userId);

    if (borrowingDocs.isNotEmpty) {
      List<BorrowingModel> borrowings = [];

      for (final borrowingDoc in borrowingDocs.toList()) {
        final borrowingMap = borrowingDoc.data() as Map<String, dynamic>;

        String classId = '';
        String majorId = '';
        String userId = '';
        String staffId = '';

        if (borrowingMap.containsKey('class_id')) {
          final classDocRef = borrowingDoc.get('class_id');
          final classDoc = await classDocRef.get();
          classId = classDoc.id;
        }

        if (borrowingMap.containsKey('major_id')) {
          final majorDocRef = borrowingDoc.get('major_id');
          final majorDoc = await majorDocRef.get();
          majorId = majorDoc.id;
        }

        if (borrowingMap.containsKey('user_id')) {
          final userDocRef = borrowingDoc.get('user_id');
          final userDoc = await userDocRef.get();
          userId = userDoc.id;
        }

        if (borrowingMap.containsKey('staff_id')) {
          final staffDocRef = borrowingDoc.get('staff_id');
          final staffDoc = await staffDocRef.get();
          staffId = staffDoc.id;
        }

        borrowings.add(BorrowingModel(
          id: borrowingDoc.id,
          classId: classId,
          majorId: majorId,
          userId: userId,
          staffId: staffId,
          title: borrowingDoc.get('title'),
          description: borrowingDoc.get('description'),
          status: borrowingDoc.get('status'),
          date: (borrowingDoc.get('date') as Timestamp).toDate(),
          timeFrom: TimeOfDay.fromDateTime((borrowingDoc.get('time_from') as Timestamp).toDate()),
          timeUntil: TimeOfDay.fromDateTime((borrowingDoc.get('time_until') as Timestamp).toDate()),
          createdAt: (borrowingDoc.get('created_at') as Timestamp).toDate(),
          rejectedMessage: borrowingDoc.get('rejected_message')
        ));
      }

      return borrowings;
    }

    return [];
  }

  @override
  Future<List<BorrowingModel>> getNotYetRespondedBorrowings() async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    final borrowingDocs = await service.getNotYetRespondedBorrowings();

    if (borrowingDocs.isNotEmpty) {
      List<BorrowingModel> borrowings = [];

      for (final borrowingDoc in borrowingDocs.toList()) {
      final borrowingMap = borrowingDoc.data() as Map<String, dynamic>;

        String classId = '';
        String majorId = '';
        String userId = '';
        String staffId = '';

        if (borrowingMap.containsKey('class_id')) {
          final classDocRef = borrowingDoc.get('class_id');
          final classDoc = await classDocRef.get();
          classId = classDoc.id;
        }

        if (borrowingMap.containsKey('major_id')) {
          final majorDocRef = borrowingDoc.get('major_id');
          final majorDoc = await majorDocRef.get();
          majorId = majorDoc.id;
        }

        if (borrowingMap.containsKey('user_id')) {
          final userDocRef = borrowingDoc.get('user_id');
          final userDoc = await userDocRef.get();
          userId = userDoc.id;
        }

        if (borrowingMap.containsKey('staff_id')) {
          final staffDocRef = borrowingDoc.get('staff_id');
          final staffDoc = await staffDocRef.get();
          staffId = staffDoc.id;
        }

        borrowings.add(BorrowingModel(
          id: borrowingDoc.id,
          classId: classId,
          majorId: majorId,
          userId: userId,
          staffId: staffId,
          title: borrowingDoc.get('title'),
          description: borrowingDoc.get('description'),
          status: borrowingDoc.get('status'),
          date: (borrowingDoc.get('date') as Timestamp).toDate(),
          timeFrom: TimeOfDay.fromDateTime((borrowingDoc.get('time_from') as Timestamp).toDate()),
          timeUntil: TimeOfDay.fromDateTime((borrowingDoc.get('time_until') as Timestamp).toDate()),
          createdAt: (borrowingDoc.get('created_at') as Timestamp).toDate(),
          rejectedMessage: borrowingDoc.get('rejected_message')
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
        staffId: staffId,
        title: borrowing['title'],
        description: borrowing['description'],
        status: borrowing['status'],
        date: borrowing['date'],
        timeFrom: borrowing['time_from'],
        timeUntil: borrowing['time_until'],
        createdAt: borrowing['created_at'],
        rejectedMessage: borrowing['rejected_message']
      );
    }

    return null;
  }
  
  @override
  Future<dynamic> checkIfBorrowingTimeIsUsed({
    required String classId,
    required DateTime date,
    required TimeOfDay timeFrom,
    required TimeOfDay timeUntil
  }) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();

    final borrowingDoc = await service.checkIfBorrowingTimeHasBooked(
      classId: classId,
      date: date,
      timeFrom: timeFrom,
      timeUntil: timeUntil
    );

    if (borrowingDoc != null) {
      final borrowingMap = borrowingDoc.data() as Map<String, dynamic>;

      String classId = '';
      String majorId = '';
      String userId = '';
      String staffId = '';

      if (borrowingMap.containsKey('class_id')) {
        final classDocRef = borrowingDoc.get('class_id');
        final classDoc = await classDocRef.get();
        classId = classDoc.id;
      }

      if (borrowingMap.containsKey('major_id')) {
        final majorDocRef = borrowingDoc.get('major_id');
        final majorDoc = await majorDocRef.get();
        majorId = majorDoc.id;
      }

      if (borrowingMap.containsKey('user_id')) {
        final userDocRef = borrowingDoc.get('user_id');
        final userDoc = await userDocRef.get();
        userId = userDoc.id;
      }

      if (borrowingMap.containsKey('staff_id')) {
        final staffDocRef = borrowingDoc.get('staff_id');
        final staffDoc = await staffDocRef.get();
        staffId = staffDoc.id;
      }

      return BorrowingModel(
        id: borrowingDoc.id,
        classId: classId,
        majorId: majorId,
        userId: userId,
        staffId: staffId,
        title: borrowingDoc.get('title'),
        description: borrowingDoc.get('description'),
        status: borrowingDoc.get('status'),
        date: (borrowingDoc.get('date') as Timestamp).toDate(),
        timeFrom: TimeOfDay.fromDateTime((borrowingDoc.get('time_from') as Timestamp).toDate()),
        timeUntil: TimeOfDay.fromDateTime((borrowingDoc.get('time_until') as Timestamp).toDate()),
        createdAt: (borrowingDoc.get('created_at') as Timestamp).toDate(),
        rejectedMessage: borrowingDoc.get('rejected_message')
      );
    }

    final isBorrowingTimeSameAsClassSchedule = await service.checkIfBorrowingTimeIsSameAsClassSchedule(
      classId: classId,
      date: date,
      timeFrom: timeFrom,
      timeUntil: timeUntil
    );

    return isBorrowingTimeSameAsClassSchedule;
  }
  
  @override
  Future<bool> acceptBorrowing({
    required String borrowingId,
    required String staffId,
  }) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    return await service.acceptBorrowing(
      borrowingId: borrowingId,
      staffId: staffId,
    );
  }

  @override
  Future<bool> rejectBorrowing({
    required String borrowingId,
    required String staffId,
    required String message
  }) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    return await service.rejectBorrowing(
      borrowingId: borrowingId,
      staffId: staffId,
      message: message
    );
  }
  
  @override
  Future<bool> cancelBorrowingById(String borrowingId) async {
    final BorrowingFirebaseService service = BorrowingFirebaseService();
    return await service.cancelBorrowingById(borrowingId);
  }
}