import 'package:flutter/material.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';

class BorrowingsViewModel extends ChangeNotifier {
  List<BorrowingModel> _borrowings = [];

  List<BorrowingModel> get borrowings => _borrowings;

  bool _isFetchingBorrowings = false;

  bool get isFetchingBorrowings => _isFetchingBorrowings;

  set isFetchingBorrowings(bool isFetching) {
    _isFetchingBorrowings = isFetching;
    notifyListeners();
  }

  bool _areBorrowingsFetched = false;

  bool get areBorrowingsFetched => _areBorrowingsFetched;

  set areBorrowingsFetched(bool isFetched) {
    _areBorrowingsFetched = isFetched;
    notifyListeners();
  }
  
  Future<void> fetchBorrowings(String classId) async {
    areBorrowingsFetched = false;
    isFetchingBorrowings = true;

    try {
      final BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      _borrowings = await repository.getBorrowingsByClassId(classId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      areBorrowingsFetched = true;
      isFetchingBorrowings = false;
    }
  }
}