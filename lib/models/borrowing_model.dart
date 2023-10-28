import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/models/major_model.dart';
import 'package:siklas/models/user_model.dart';
import 'package:siklas/repositories/borrowing_firebase_repository.dart';
import 'package:siklas/repositories/class_firebase_repository.dart';
import 'package:siklas/repositories/major_firebase_repository.dart';
import 'package:siklas/repositories/user_firebase_repository.dart';

class BorrowingModel {
  String id;
  String classId;
  String majorId;
  String userId;
  String? staffId;
  String title;
  String description;
  int status;
  DateTime date;
  TimeOfDay timeFrom;
  TimeOfDay timeUntil;
  String? rejectedMessage;
  DateTime createdAt;

  BorrowingModel({
    required this.id,
    required this.classId,
    required this.majorId,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.timeFrom,
    required this.timeUntil,
    required this.createdAt,
    this.staffId,
    this.rejectedMessage
  });

  Future<ClassModel?> getClassModel() async {
    ClassFirebaseRepository repository = ClassFirebaseRepository();
    final classModel = await repository.getClassById(classId);

    if (classModel != null) return classModel;

    return null;
  }

  Future<MajorModel?> getMajorModel() async {
    MajorFirebaseRepository repository = MajorFirebaseRepository();
    final majorModel = await repository.getMajorById(majorId);

    if (majorModel != null) return majorModel;

    return null;
  }

  Future<UserModel?> getUserModel() async {
    UserFirebaseRepository repository = UserFirebaseRepository();
    final userModel = await repository.getUserById(userId);

    if (userModel != null) return userModel;

    return null;
  }

  Future<UserModel?> getStaffModel() async {
    UserFirebaseRepository repository = UserFirebaseRepository();
    final userModel = await repository.getUserById(userId);

    if (userModel != null) return userModel;

    return null;
  }

  String getStatus() {
    if (status == 0) return 'Menunggu persetujuan';
    if (status == 1) return 'Tidak disetujui';
    return 'Disetujui';
  }

  String dateFormatted() {
    return DateFormat('d MMMM y').format(date);
  }

  String createdAtFormattedDate() {
    return DateFormat('d MMMM y').format(createdAt);
  }

  String createdAtFormattedTime() {
    return DateFormat('HH:mm').format(createdAt);
  }

  String timeFromFormatted(context) {
    final date = DateFormat("h:mm a").parse(timeFrom.format(context));
    return DateFormat("HH:mm").format(date);
  }

  String timeUntilFormatted(context) {
    final date = DateFormat("h:mm a").parse(timeUntil.format(context));
    return DateFormat("HH:mm").format(date);
  }
}