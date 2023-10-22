import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';

class BorrowingViewModel extends ChangeNotifier {
  List<BorrowingModel> _borrowings = [];

  List<BorrowingModel> get borrowings => _borrowings;

  bool _isFetchingBorrowings = false;

  bool get isFetchingBorrowings => _isFetchingBorrowings;

  set isFetchingBorrowings(bool isFetching) {
    _isFetchingBorrowings = isFetching;
    notifyListeners();
  }

  bool _isBorrowingsFetched = false;

  bool get isBorrowingsFetched => _isBorrowingsFetched;

  set isBorrowingsFetched(bool isFetched) {
    _isBorrowingsFetched = isFetched;
    notifyListeners();
  }
  
  Future<void> fetchBorrowings(String classId) async {
    isBorrowingsFetched = false;
    isFetchingBorrowings = true;

    try {
      final BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      _borrowings = await repository.getBorrowingsByClassId(classId);
    } on Exception catch (_) {
      // TODO
    } finally {
      isBorrowingsFetched = true;
      isFetchingBorrowings = false;
    }
  }
}