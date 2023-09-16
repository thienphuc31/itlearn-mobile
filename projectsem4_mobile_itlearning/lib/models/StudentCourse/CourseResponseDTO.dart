import 'CategoryCourseDto.dart';

class CourseResponseDTO {
  int id;
  String title;
  String status;
  String thumbnail;
  int totalDuration;
  int totalVideo;
  int totalExercise;
  CategoryCourseDto courseCategory;

  CourseResponseDTO({
    required this.id,
    required this.title,
    required this.status,
    required this.thumbnail,
    required this.totalDuration,
    required this.totalVideo,
    required this.totalExercise,
    required this.courseCategory,
  });

  factory CourseResponseDTO.fromJson(Map<String, dynamic> json) {
    return CourseResponseDTO(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      thumbnail: json['thumbnail'],
      totalDuration: json['totalDuration'],
      totalVideo: json['totalVideo'],
      totalExercise: json['totalExercise'],
      courseCategory: CategoryCourseDto.fromJson(json['courseCategory']),
    );
  }
}