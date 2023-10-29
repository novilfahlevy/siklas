import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';

class BorrowingHistoriesViewModel extends ChangeNotifier {
  List<BorrowingModel> _borrowings = [];

  List<BorrowingModel> get borrowings => _borrowings;

  bool _isFetchingBorrowings = false;

  bool get isFetchingBorrowings => _isFetchingBorrowings;

  set isFetchingBorrowings(bool isFetching) {
    _isFetchingBorrowings = isFetching;
    notifyListeners();
  }
  
  Future<void> fetchBorrowingsByUserId(String userId) async {
    isFetchingBorrowings = true;

    try {
      final BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      _borrowings = await repository.getBorrowingsByUserId(userId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      isFetchingBorrowings = false;
    }
  }
}