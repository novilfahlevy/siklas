import 'package:flutter/foundation.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/major_firebase_repository.dart';

class BorrowingViewModel extends ChangeNotifier {
  BorrowingModel? _borrowing;

  BorrowingModel? get borrowing => _borrowing;

  set borrowing(BorrowingModel? borrowing) {
    _borrowing = borrowing;
    notifyListeners();
  }

  MajorModel? _major;

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
      _borrowing = await borrowingRepository.getBorrowingById(borrowingId);

      if (_borrowing != null) {
        final MajorFirebaseRepository majorRepository = MajorFirebaseRepository();
        _major = await majorRepository.getMajorById(_borrowing!.majorId);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      isFetchingBorrowing = false;
    }
  }
}