import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/floor_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/models/user_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/class_firebase_repository.dart';
import 'package:siklas/repositories/floor_firebase_repository.dart';
import 'package:siklas/repositories/major_firebase_repository.dart';
import 'package:siklas/repositories/user_firebase_repository.dart';

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

  UserModel? _staffModel;

  UserModel? get staffModel => _staffModel;

  set staffModel(UserModel? staffModel) {
    _staffModel = staffModel;
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

    borrowingModel = null;
    classModel = null;
    floorModel = null;
    majorModel = null;
    staffModel = null;

    try {
      final BorrowingFirebaseRepository borrowingRepository = BorrowingFirebaseRepository();
      final ClassFirebaseRepository classRepository = ClassFirebaseRepository();
      final FloorFirebaseRepository floorRepository = FloorFirebaseRepository();
      final MajorFirebaseRepository majorRepository = MajorFirebaseRepository();
      final UserFirebaseRepository userRepository = UserFirebaseRepository();

      borrowingModel = await borrowingRepository.getBorrowingById(borrowingId);
      classModel = await classRepository.getClassById(borrowingModel!.classId);
      floorModel = await floorRepository.getFloorById(classModel!.floorId);
      majorModel = await majorRepository.getMajorById(borrowingModel!.majorId);

      if (borrowingModel!.staffId != '') {
        staffModel = await userRepository.getUserById(borrowingModel!.staffId!);
      }
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

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    await repository.acceptBorrowing(
      borrowingId: borrowingModel!.id,
      staffId: userId!
    );

    isAcceptingBorrowing = false;
  }
}