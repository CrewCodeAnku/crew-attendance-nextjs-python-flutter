import 'package:crew_attendance/core/models/student.dart';

class Attendance {
  final String? id;
  final String? present;
  final String? absent;
  final String? classImage;
  final String? courseId;
  final String? attendanceDate;
  List<Student>? studentParticipated;

  Attendance(
      {this.id,
      this.present,
      this.absent,
      this.classImage,
      this.courseId,
      this.attendanceDate,
      this.studentParticipated});

  factory Attendance.fromJson(Map<String, dynamic> json) {

    print("Json Attendance");
    print(json);

    final participantData = json['studentParticipated'] as List<dynamic>?;
    final participants = participantData != null
        ? participantData.map((participantData) => Student.fromJson(participantData)).toList() : <Student>[];

    return Attendance(
        id: json['id'] ?? "",
        present: json['present'] ?? "",
        absent: json['absent'] ?? "",
        classImage: json['classImage'] != ""
            ? json['classImage']
            : "https://img.icons8.com/external-sbts2018-flat-sbts2018/58/000000/external-user-ecommerce-basic-1-sbts2018-flat-sbts2018.png",
        courseId: json['courseId'] ?? "",
        attendanceDate: json['attendanceDate'] ?? "",
        studentParticipated: participants
    );
  }
}

