import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:projectsem4_mobile_itlearning/constants/urlAPI.dart';
import 'package:projectsem4_mobile_itlearning/models/StudentCourse/Course.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../constants/AuthenticatedHttpClient.dart';
import '../models/ApiResponse.dart';
import '../models/StudentCourse/CourseStudentResponseDTO.dart';
import 'AccountProvider.dart';


class StudentCourseProvider extends ChangeNotifier {
  List<Course> _course = [];
  AuthenticatedHttpClient _httpClient; // Thêm một trường cho AuthenticatedHttpClient

  List<Course> get course => _course;

  StudentCourseProvider(this._httpClient); // Inject AuthenticatedHttpClient

  // Phương thức để lấy danh sách StudentCourse
  Future<void> fetchStudentCourses(BuildContext context) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
          domain + 'api/course/list-course-learning',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);

        if (apiResponse.success) {
          final List<dynamic> courseData = apiResponse.data;
          _course = courseData
              .map((item) => Course.fromJson(item))
              .toList();
          notifyListeners(); // notifying listeners about the change
        } else {
          // Handle success with no data if needed
          _course = [];
          notifyListeners(); // notifying listeners about the change
        }
      }else if (response.statusCode == 401) {
        await Provider.of<AccountProvider>(context, listen: false).logOut(context);
      }
      else {
        // Handle error if needed
        throw Exception('Failed to fetch student courses');
      }
    } catch (e) {
      // Handle network or other errors if needed
      throw Exception('Failed to fetch student courses: $e');
    }
  }

}
