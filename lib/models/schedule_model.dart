import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleModel {
  String id;
  String title;
  DateTime day;
  TimeOfDay timeFrom;
  TimeOfDay timeUntil;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.day,
    required this.timeFrom,
    required this.timeUntil
  });

  String dayFormatted() {
    return DateFormat('EEEE').format(day);
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