import 'package:flutter/foundation.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/major_firebase_repository.dart';

class DetailBorrowingViewModel extends ChangeNotifier {
  BorrowingModel? _borrowing = null;

  BorrowingModel? get borrowing => _borrowing;

  set borrowing(BorrowingModel? borrowing) {
    _borrowing = borrowing;
    notifyListeners();
  }

  MajorModel? _major = null;

  MajorModel? get major => _major;

  set major(MajorModel? major) {
    _major = major;
    notifyListeners();
  }

  bool _isFetchingBorrowing = true;

  bool get isFetchingBorrowing => _isFetchingBorrowing;

  set isFetchingBorrowing(bool isFetching) {
    _isFetchingBorrowing = isFetching;
    notifyListeners();
  }

  Future<void> fetchBorrowingById(String borrowingId) async {
    isFetchingBorrowing = true;

    try {
      final BorrowingFirebaseRepository borrowingRepository = BorrowingFirebaseRepository();
      final borrowing = await borrowingRepository.getBorrowingById(borrowingId);

      _borrowing = borrowing;

      final MajorFirebaseRepository majorRepository = MajorFirebaseRepository();
      final major = await majorRepository.getMajorById(_borrowing!.majorId);

      _major = major;
    } on Exception catch (_) {
      // TODO
    } finally {
      isFetchingBorrowing = false;
    }
  }
}