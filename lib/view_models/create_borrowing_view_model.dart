import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siklas/models/borrowing_model.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/major_firebase_repository.dart';

class CreateBorrowingViewModel extends ChangeNotifier {
  ClassModel? _currentClass;
  
  ClassModel? get currentClass => _currentClass;

  set currentClass(ClassModel? classModel) {
    _currentClass = classModel;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  List<MajorModel> _majors = [];

  List<MajorModel> get majors => _majors;

  MajorModel? _selectedMajor;
  
  MajorModel? get selectedMajor => _selectedMajor;

  set selectedMajor(MajorModel? major) {
    _selectedMajor = major;
  }

  MajorModel? get firstMajor => majors.isNotEmpty ? majors.first : null;

  DateTime _date = DateTime.now();

  DateTime get date => _date;

  set date(DateTime date) {
    _date = date;
    notifyListeners();
  }

  TimeOfDay _timeFrom = TimeOfDay.now();

  TimeOfDay get timeFrom => _timeFrom;

  set timeFrom(TimeOfDay timeFrom) {
    _timeFrom = timeFrom;
    notifyListeners();
  }

  TimeOfDay _timeUntil = TimeOfDay.now();

  TimeOfDay get timeUntil => _timeUntil;

  set timeUntil(TimeOfDay timeUntil) {
    _timeUntil = timeUntil;
    notifyListeners();
  }

  bool _isFetchingMajors = true;

  bool get isFetchingMajors => _isFetchingMajors;

  set isFetchingMajors(bool isFetching) {
    _isFetchingMajors = isFetching;
    notifyListeners();
  }

  bool _isSubmittingBorrowing = false;

  bool get isSubmittingBorrowing => _isSubmittingBorrowing;

  set isSubmittingBorrowing(bool isSubmitting) {
    _isSubmittingBorrowing = isSubmitting;
    notifyListeners();
  }

  bool _isTimeValid = true;

  bool get isTimeValid => _isTimeValid;

  set isTimeValid(bool isSubmitting) {
    _isTimeValid = isSubmitting;
    notifyListeners();
  }

  bool _isBorrowingCreated = false;

  bool get isBorrowingCreated => _isBorrowingCreated;

  set isBorrowingCreated(bool isSubmitting) {
    _isBorrowingCreated = isSubmitting;
    notifyListeners();
  }

  Future<void> fetchMajors() async {
    isFetchingMajors = true;

    try {
      final MajorFirebaseRepository repository = MajorFirebaseRepository();
      _majors = await repository.getMajors();
      
      selectedMajor = firstMajor;
    } on Exception catch (_) {
      // TODO
    } finally {
      isFetchingMajors = false;
    }
  }

  Future<void> submitBorrowing() async {
    bool isTimeValid = validateTime();
    bool isFormValid = formKey.currentState!.validate();
    
    if (isTimeValid && isFormValid) {
      isSubmittingBorrowing = true;
      isBorrowingCreated = false;

      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      final BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      final BorrowingModel? borrowing = await repository.createBorrowing(
        classId: currentClass!.id,
        majorId: selectedMajor!.id,
        userId: userId!,
        title: titleController.text,
        description: descriptionController.text,
        status: 0,
        date: date,
        timeFrom: timeFrom,
        timeUntil: timeUntil,
      );

      if (borrowing != null) {
        titleController.clear();
        descriptionController.clear();
        selectedMajor = firstMajor;
        date = DateTime.now();
        timeFrom = TimeOfDay.now();
        timeUntil = TimeOfDay.now();

        isBorrowingCreated = true;
      }

      isSubmittingBorrowing = false;
    }
  }

  String? validateName(String? value) {
    if (value == '') {
      return 'Nama kegiatan perlu diisi';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == '') {
      return 'Keterangan kegiatan perlu diisi';
    }

    return null;
  }

  bool validateTime() {
    isTimeValid = false;

    final from = DateTime(date.year, date.month, date.day, timeFrom.hour, timeFrom.minute);
    final to = DateTime(date.year, date.month, date.day, timeUntil.hour, timeUntil.minute);
    
    if (!(from.isAfter(to) || to.isBefore(from) || from.isAtSameMomentAs(to))) {
      isTimeValid = true;
    }

    return isTimeValid;
  }
}