import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';

abstract class BorrowingRepositoryInterface {
  Future<BorrowingModel?> getBorrowingById(String borrowingId);

  Future<List<BorrowingModel>> getBorrowingsByClassId(String classId);

  Future<List<BorrowingModel>> getBorrowingsByUserId(String userId);

  Future<List<BorrowingModel>> getNotYetRespondedBorrowings();

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
  });

  Future<bool> cancelBorrowingById(String borrowingId);
}