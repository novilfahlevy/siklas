import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool _isBorrowingsFetched = false;

  bool get isBorrowingsFetched => _isBorrowingsFetched;

  set isBorrowingsFetched(bool isFetched) {
    _isBorrowingsFetched = isFetched;
    notifyListeners();
  }
  
  Future<void> fetchBorrowingsByUserId() async {
    isBorrowingsFetched = false;
    isFetchingBorrowings = true;

    try {
      final BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      final prefs = await SharedPreferences.getInstance();
      
      final userId = prefs.getString('userId');
      _borrowings = await repository.getBorrowingsByUserId(userId!);

      isBorrowingsFetched = _borrowings.isNotEmpty;
    } on Exception catch (_) {
      // TODO
    } finally {
      isFetchingBorrowings = false;
    }
  }
}