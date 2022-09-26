class Course {
  final String? id;
  final String? courseName;
  final String? courseShortName;
  final String? courseStartDate;
  final String? courseEndDate;

  Course(
      {this.id,
      this.courseName,
      this.courseShortName,
      this.courseStartDate,
      this.courseEndDate,});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        id: json['id'] ?? "",
        courseName: json['courseName'] ?? "",
        courseShortName: json['courseShortName'] ?? "",
        courseStartDate: json['courseStartDate'] ?? "",
        courseEndDate: json['courseEndDate'] ?? "");
  }
}

