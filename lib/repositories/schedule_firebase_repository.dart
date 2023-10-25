import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siklas/models/schedule_model.dart';
import 'package:siklas/repositories/interfaces/schedule_repository_interface.dart';
import 'package:siklas/services/schedule_firebase_service.dart';
import 'package:intl/intl.dart';

class ScheduleFirebaseRepository implements ScheduleRepositoryInterface {
  @override
  Future<List<ScheduleModel>> getSchedules(String classId) async {
    final ScheduleFirebaseService service = ScheduleFirebaseService();
    final scheduleDocs = await service.getSchedules(classId);

    if (scheduleDocs.isNotEmpty) {
      return scheduleDocs
        .toList()
        .map((final scheduleDoc) => ScheduleModel(
          id: scheduleDoc.id,
          title: scheduleDoc.get('title'),
          day: (scheduleDoc.get('day') as Timestamp).toDate(),
          timeFrom: TimeOfDay.fromDateTime((scheduleDoc.get('time_from') as Timestamp).toDate()),
          timeUntil: TimeOfDay.fromDateTime((scheduleDoc.get('time_until') as Timestamp).toDate()),
        ))
        .toList();
    }

    return [];
  }

  DateTime convertTimestampToDateTime(dynamic timestamp) {
    return (timestamp as Timestamp).toDate();
  }

  String convertDatetimeToDay(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  String convertDatetimeToTime(DateTime date) {
    return DateFormat('Hm').format(date);
  }
}