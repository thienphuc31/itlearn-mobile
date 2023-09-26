import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/providers/AccountProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/AuthenticatedHttpClient.dart';
import '../constants/urlAPI.dart';
import '../models/ApiResponse.dart';
import '../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../models/Lesson/ItemOfLesson/Theory/SubmitTheory/SubmitTheoryExerciseDTO.dart';
import '../screens/TheoryExercise/DoExercisePage.dart';
import '../widgets/ExampleSnackbar.dart';

class ExerciseProvider extends ChangeNotifier {
  ExerciseData? submittedExerciseData;

  AuthenticatedHttpClient _httpClient;

  ExerciseProvider(this._httpClient);


  // Other methods to manipulate _exerciseData go here


  Future<ExerciseData?> getSubmittedExerciseData() async {
    return submittedExerciseData;
  }
  Future<void> getTheoryExercise(int theoryExerciseId, BuildContext context) async {
    final response = await _httpClient.get(Uri.parse(domain + 'api/theory/getTheoryExercise/$theoryExerciseId'));
    submittedExerciseData = new ExerciseData();
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(responseData);

      if (apiResponse.success) {
        if (apiResponse.data != null) {
          var dataMap = apiResponse.data as Map<String, dynamic>;

          if (dataMap['status'] == "WORKING" || dataMap['status'] == "SUBMITTED") {
            ExerciseData exerciseData = ExerciseData.fromJson(dataMap);

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
    } else if (response.statusCode == 401) {
      await Provider.of<AccountProvider>(context, listen: false).logOut(context);
    } else if (response.statusCode == 500){
      // Show dialog before starting the theory exercise
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Test'),
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.warning, // this is the warning icon
                  color: Colors.red,
                ),
                SizedBox(width: 10), // to add some space between the icon and the text
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'WARNING: ',
                          style: DefaultTextStyle.of(context).style.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'when you click start, you will have 15 minutes to complete the test and you cannot retake the quiz.',
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Start QUIZ'),
                onPressed: () async {
                  await startTheoryExercise(theoryExerciseId, context);
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DoExercisePage(),
                  ));
                },
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Failed to load theory exercise');
    }
  }
  Future<bool> submitTheoryExercise(int theoryExerciseId, SubmitTheoryExerciseDTO data) async {
    final url = Uri.parse(domain + 'api/theory/submit/$theoryExerciseId');
    final response = await _httpClient.post(
      url,
      body: json.encode(data.toJson()),
      headers: {
        "Content-Type": "application/json"
      }
    );
    // Return whether the submission was successful or not
    return response.statusCode == 200;
  }


  Future<void> submitHWExercise(int hwId, String link, BuildContext context) async {
    final url = Uri.parse(domain + 'api/exercise/submit/$hwId');
    final response = await _httpClient.post(
        url,
        body: jsonEncode({
          "urlDocument": link
        }),
        headers: {
          "Content-Type": "application/json"
        }
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    final apiResponse = ApiResponse.fromJson(responseData);
    SnackBarShowError(context, apiResponse.message);
  }

  Future<void> startTheoryExercise(int theoryExerciseId, BuildContext context) async {
    final url = Uri.parse(domain + 'api/theory/start/$theoryExerciseId');
    try {
      final response = await _httpClient.post(url);

      // Check the status code of the response
      if (response.statusCode == 200) {
        await getTheoryExercise(theoryExerciseId, context);
        final Map<String, dynamic> responseData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);
        if(apiResponse.success){

        }else{
          SnackBarShowError(context, "Failed to load theory exercise");
        }
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseData);
        SnackBarShowError(context, apiResponse.message);
      }
    } catch (e) {
      SnackBarShowError(context, "Failed to load theory exercise");
    }
  }
}