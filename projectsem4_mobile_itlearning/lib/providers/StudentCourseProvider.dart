import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:projectsem4_mobile_itlearning/constants/urlAPI.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../constants/AuthenticatedHttpClient.dart';
import '../models/ApiResponse.dart';
import '../models/StudentCourse/CourseStudentResponseDTO.dart';


class StudentCourseProvider extends ChangeNotifier {
  List<CourseStudentResponseDTO> _studentCourses = [];
  AuthenticatedHttpClient _httpClient; // Thêm một trường cho AuthenticatedHttpClient

  List<CourseStudentResponseDTO> get studentCourses => _studentCourses;

  StudentCourseProvider(this._httpClient); // Inject AuthenticatedHttpClient

  // Phương thức để lấy danh sách StudentCourse
  Future<List<CourseStudentResponseDTO>> fetchStudentCourses() async {
    try {
      final response = await _httpClient.get(
        Uri.parse(domain+ 'api/student/getListCourse'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);

        if (apiResponse.success) {
          final List<dynamic> courseData = apiResponse.data;
          final List<CourseStudentResponseDTO> studentCourses = courseData
              .map((item) => CourseStudentResponseDTO.fromJson(item))
              .toList();
          return studentCourses;
        } else {
          // Handle success with no data if needed
          return [];
        }
      } else {
        // Handle error if needed
        throw Exception('Failed to fetch student courses');
      }
    } catch (e) {
      // Handle network or other errors if needed
      throw Exception('Failed to fetch student courses: $e');
    }
  }

}
