import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    this.staffId,
    this.rejectedMessage
  });

  String dateFormatted() {
    return DateFormat('d MMMM y').format(date);
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