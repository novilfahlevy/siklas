import 'package:flutter/foundation.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/class_firebase_repository.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';
import 'package:siklas/repositories/major_firebase_repository.dart';

class StaffBorrowingViewModel extends ChangeNotifier {
  BorrowingModel? _borrowingModel;

  BorrowingModel? get borrowingModel => _borrowingModel;

  set borrowingModel(BorrowingModel? borrowingModel) {
    _borrowingModel = borrowingModel;
    notifyListeners();
  }

  ClassModel? _classModel;

  ClassModel? get classModel => _classModel;

  set classModel(ClassModel? classModel) {
    _classModel = classModel;
    notifyListeners();
  }

  FloorModel? _floorModel;

  FloorModel? get floorModel => _floorModel;

  set floorModel(FloorModel? floorModel) {
    _floorModel = floorModel;
    notifyListeners();
  }

  MajorModel? _majorModel;

  MajorModel? get majorModel => _majorModel;

  set majorModel(MajorModel? majorModel) {
    _majorModel = majorModel;
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
      final ClassFirebaseRepository classRepository = ClassFirebaseRepository();
      final FloorFirebaseRepository floorRepository = FloorFirebaseRepository();
      final MajorFirebaseRepository majorRepository = MajorFirebaseRepository();

      _borrowingModel = await borrowingRepository.getBorrowingById(borrowingId);
      _classModel = await classRepository.getClassById(_borrowingModel!.classId);
      _floorModel = await floorRepository.getFloorById(_classModel!.floorId);
      _majorModel = await majorRepository.getMajorById(_borrowingModel!.majorId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      isFetchingBorrowing = false;
    }
  }

  bool _isAcceptingBorrowing = false;

  bool get isAcceptingBorrowing => _isAcceptingBorrowing;

  set isAcceptingBorrowing(bool isFetching) {
    _isAcceptingBorrowing = isFetching;
    notifyListeners();
  }

  Future<void> acceptBorrowing() async {
    isAcceptingBorrowing = true;

    BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
    await repository.acceptBorrowing(borrowingModel!.id);

    isAcceptingBorrowing = false;
  }
}