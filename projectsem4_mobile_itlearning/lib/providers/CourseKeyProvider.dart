import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectsem4_mobile_itlearning/constants/urlAPI.dart';
import 'package:provider/provider.dart';

import '../constants/AuthenticatedHttpClient.dart';
import '../models/ApiResponse.dart';
import '../models/CourseKey/CourseKey.dart';
import '../models/Lesson/Lesson.dart';
import '../widgets/ExampleSnackbar.dart';
import 'AccountProvider.dart';

class CourseKeyProvider with ChangeNotifier {
  Map<int, List<CourseKey>> _courses = {};
  AuthenticatedHttpClient _httpClient;
  List<Lesson> lessons = [];
  CourseKeyProvider(this._httpClient);

  List<CourseKey> getCourseKeys(int courseId) => _courses[courseId] ?? [];


  Future<void> fetchCourseKeyList(int courseId, BuildContext context) async {
    try {
      final response = await _httpClient.get(Uri.parse(domain + 'api/course-key/list-learning/$courseId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);

        if (apiResponse.success) {
          var data = apiResponse.data as List;
          _courses[courseId] = data.map((course) => CourseKey.fromJson(course)).toList();

          notifyListeners(); // notifying listeners about the change
        } else {
          // Handle success with no data if needed
          _courses[courseId] = [];
          notifyListeners(); // notifying listeners about the change
        }
      } else if (response.statusCode == 401) {
        await Provider.of<AccountProvider>(context, listen: false).logOut(context);
      }else {
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
  Future<void> completeItemofLesson(int iolId, BuildContext context) async {

    try {
      final response = await _httpClient.post(Uri.parse(domain + 'api/item-of-lesson/complete-item-lesson/$iolId'));
      final Map<String, dynamic> responseData = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(responseData);
      SnackBarShowSuccess(context, apiResponse.message);
    } catch (e) {
      throw Exception('Failed to complete Item of Lesson');
    }
  }

}