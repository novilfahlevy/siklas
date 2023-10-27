import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';

class StaffBorrowingsViewModel extends ChangeNotifier {
  List<BorrowingModel> _borrowings = [];

  List<BorrowingModel> get borrowings => _borrowings;

  bool _isFetchingBorrowings = true;

  bool get isFetchingBorrowings => _isFetchingBorrowings;

  set isFetchingBorrowings(bool isFetching) {
    _isFetchingBorrowings = isFetching;
    notifyListeners();
  }

  Future<void> fetchNotYetRespondedBorrowings() async {
    try {
      final BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      _borrowings = await repository.getNotYetRespondedBorrowings();
    } on Exception catch (_) {
      // TODO
    } finally {
      isFetchingBorrowings = false;
    }
  }
}