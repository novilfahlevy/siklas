import 'package:siklas/models/borrowing_model.dart';

abstract class BorrowingRepositoryInterface {
  Future<List<BorrowingModel>> getBorrowingsByClassId(String classId);
}