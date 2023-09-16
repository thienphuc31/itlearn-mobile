import 'CourseResponseDTO.dart';

class CourseStudentResponseDTO {
  int id;
  DateTime startCourseDate;
  DateTime endCourseDate;
  int status;
  CourseResponseDTO course;
  int studentId;

  CourseStudentResponseDTO({
    required this.id,
    required this.startCourseDate,
    required this.endCourseDate,
    required this.status,
    required this.course,
    required this.studentId,
  });

  factory CourseStudentResponseDTO.fromJson(Map<String, dynamic> json) {
    return CourseStudentResponseDTO(
      id: json['id'],
      startCourseDate: DateTime.parse(json['startCourseDate']),
      endCourseDate: DateTime.parse(json['endCourseDate']),
      status: json['status'],
      course: CourseResponseDTO.fromJson(json['course']),
      studentId: json['studentId'],
    );
  }
}