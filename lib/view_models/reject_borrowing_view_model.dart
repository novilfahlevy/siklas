import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';

class RejectBorrowingViewModel extends ChangeNotifier {
  String _borrowingId = '';

  String get borrowingId => _borrowingId;

  set borrowingId(String isSubmitting) => _borrowingId = isSubmitting;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController messageController = TextEditingController();

  bool _isSubmittingMessage = false;

  bool get isSubmittingMessage => _isSubmittingMessage;

  set isSubmittingMessage(bool isFetching) {
    _isSubmittingMessage = isFetching;
    notifyListeners();
  }

  bool _isMessageSubmitted = false;

  bool get isMessageSubmitted => _isMessageSubmitted;

  set isMessageSubmitted(bool isFetching) {
    _isMessageSubmitted = isFetching;
    notifyListeners();
  }

  Future<void> submitMessage() async {
    isMessageSubmitted = false;
    isSubmittingMessage = true;

    if (formKey.currentState!.validate()) {
      BorrowingFirebaseRepository repository = BorrowingFirebaseRepository();
      
      final prefs = await SharedPreferences.getInstance();
      String? staffId = prefs.getString('userId');

      await repository.rejectBorrowing(
        borrowingId: _borrowingId,
        staffId: staffId!,
        message: messageController.text
      );

      messageController.clear();

      isMessageSubmitted = true;
    }

    isSubmittingMessage = false;
  }

  String? validateMessage(String? value) {
    if (value == '') {
      return 'Mohon isi keterangan penolakan';
    }

    return null;
  }
}