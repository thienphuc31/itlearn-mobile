import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectsem4_mobile_itlearning/constants/urlAPI.dart';

import '../constants/AuthenticatedHttpClient.dart';
import '../models/ApiResponse.dart';
import '../models/CourseKey/CourseKey.dart';
import '../models/Lesson/Lesson.dart';

class CourseKeyProvider with ChangeNotifier {
  List<CourseKey> _courseList = [];
  AuthenticatedHttpClient _httpClient;
  List<Lesson> lessons = [];
  CourseKeyProvider(this._httpClient);

  List<CourseKey> get courseList => _courseList;

  Future<void> fetchCourseKeyList(int courseId) async {
    try {
      final response = await _httpClient.get(Uri.parse(domain + 'api/course-key/list-of-student/$courseId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);

        if (apiResponse.success) {
          var data = apiResponse.data as List;
          _courseList = data.map((course) => CourseKey.fromJson(course)).toList();

          notifyListeners(); // notifying listeners about the change
        } else {
          // Handle success with no data if needed
          _courseList;
          notifyListeners(); // notifying listeners about the change
        }
      } else {
        // Handle error if needed
        throw Exception('Failed to fetch student courses');
      }
    } catch (e) {
      // TODO: handle exception
    }
  }
  Future<List<Lesson>> fetchCourseData(int courseKeyId) async {
    final response = await _httpClient.get(Uri.parse(domain + 'api/lesson/list-of-student/$courseKeyId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(responseData);
      if (apiResponse.success) {
        var data = apiResponse.data as List;
        lessons = data.map((course) => Lesson.fromJson(course)).toList();
      }
      notifyListeners();
      return lessons; // notifying listeners about the change
    } else {
      throw Exception('Failed to load lesson');
    }
  }
}