import 'dart:convert';

import 'package:flutter/material.dart';

import '../constants/AuthenticatedHttpClient.dart';
import '../constants/urlAPI.dart';
import '../models/ApiResponse.dart';
import '../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../models/Lesson/ItemOfLesson/Theory/SubmitTheory/SubmitTheoryExerciseDTO.dart';

class ExerciseProvider extends ChangeNotifier {
  ExerciseData? submittedExerciseData;

  AuthenticatedHttpClient _httpClient;

  ExerciseProvider(this._httpClient);

  Future<void> getTheoryExercise(int theoryExerciseId) async {
    final response = await _httpClient.get(Uri.parse(domain + 'api/theory/getTheoryExercise/$theoryExerciseId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(responseData);

      if (apiResponse.success) {
        if (apiResponse.data != null) {
          var dataMap = apiResponse.data as Map<String, dynamic>;

          if (dataMap['status'] == "WORKING" || dataMap['status'] == "SUBMITTED") {
            ExerciseData exerciseData = ExerciseData.fromJson(dataMap);
            submittedExerciseData = new ExerciseData();
            // Only notify listeners if the submittedExerciseData has changed
            if (submittedExerciseData != exerciseData) {
              submittedExerciseData = exerciseData;
              notifyListeners();
            }
          } else {
            throw Exception('Invalid status');
          }
        } else {
          throw Exception('Data is null');
        }
      } else {
        throw Exception('Failed to load theory exercise');
      }
    } else {
      throw Exception('Failed to load theory exercise');
    }
  }

  Future<bool> submitTheoryExercise(int theoryExerciseId, SubmitTheoryExerciseDTO data) async {
    final url = Uri.parse(domain + 'api/theory/submit/$theoryExerciseId');
    final response = await _httpClient.post(
      url,
      body: json.encode(data.toJson()),
    );

    // Return whether the submission was successful or not
    return response.statusCode == 200;
  }
}