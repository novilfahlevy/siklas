class BorrowingModel {
  String id;
  String classId;
  String majorId;
  String userId;
  String? staffId;
  String title;
  String description;
  int status;
  String date;
  String timeFrom;
  String timeUntil;
  String? rejectedMessage;

  BorrowingModel({
    required this.id,
    required this.classId,
    required this.majorId,
    required this.userId,
    required this.staffId,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.timeFrom,
    required this.timeUntil,
    required this.rejectedMessage
  });
}