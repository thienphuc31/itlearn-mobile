import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../../providers/ExerciseProvider.dart';

class SubmittedExercisesPage extends StatefulWidget {
  @override
  _SubmittedExercisesPageState createState() => _SubmittedExercisesPageState();
}

class _SubmittedExercisesPageState extends State<SubmittedExercisesPage> {
  int currentQuestionIndex = 0;
  final answerLabels = ['A', 'B', 'C', 'D'];

  String _replaceBlankWithInput(String questionContent, List<String> inputs) {
    var inputIndex = 0;
    return questionContent.replaceAllMapped('_blank_', (match) {
      final replacement = inputIndex < inputs.length ? '______' : '______';
      inputIndex++;
      return replacement;
    });
  }

  Color _determineBorderColor(bool? yourChoice, bool? isTrue) {
    if (yourChoice == true && isTrue == false) {
      return Colors.red;
    } else if (yourChoice == true && isTrue == true) {
      return Colors.green;
    } else if (yourChoice == false && isTrue == false) {
      return Colors.black;
    } else if (yourChoice == false && isTrue == true) {
      return Colors.orange;
    } else {
      return Colors.grey; // Default color
    }
  }

  String _getQuestionTypeDescription(String typeQuestion) {
    switch (typeQuestion) {
      case 'SINGLE_CHOICE':
        return 'Choose 1 correct answer';
      case 'MULTIPLE_CHOICE':
        return 'Choose the correct answers';
      case 'WRITE_FILL_BLANK':
        return 'Fill in the blank';
      default:
        return 'Question type unknown';
    }
  }


  @override
  Widget build(BuildContext context) {
    ExerciseData? exerciseData = Provider.of<ExerciseProvider>(context).submittedExerciseData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted: ${exerciseData!.name}'),
        backgroundColor: primaryBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (exerciseData != null && exerciseData.result!.length > currentQuestionIndex)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                  children: [
                    Text(
                      'Câu ${currentQuestionIndex + 1}: ${_getQuestionTypeDescription(exerciseData.result![currentQuestionIndex].typeQuestion!)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Mark : ${exerciseData.result![currentQuestionIndex].mark!}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            if (exerciseData != null && exerciseData.result!.length > currentQuestionIndex)
              Container(

                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink[50], // a lighter pink color for the background
                   // a pink border with increased width
                  borderRadius: BorderRadius.circular(20), // increased border radius for more rounded corners
                ),
                margin: EdgeInsets.all(20), // increased margin
                padding: EdgeInsets.all(20), // increased padding
                child: exerciseData.result![currentQuestionIndex].questionContent!.contains('_blank_')
                    ? Text(_replaceBlankWithInput(
                  exerciseData.result![currentQuestionIndex].questionContent!,
                  exerciseData.result![currentQuestionIndex].answers!.yourInputs!,
                ))
                    : Text(exerciseData.result![currentQuestionIndex].questionContent!),
              ),
            if (exerciseData != null && exerciseData.result!.length > currentQuestionIndex)
              Expanded(
                child: Container(
                  child: exerciseData.result![currentQuestionIndex].typeQuestion != "WRITE_FILL_BLANK"
                      ? GridView.builder(
                    itemCount: exerciseData.result![currentQuestionIndex].answers!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // change this number as needed
                      childAspectRatio:3.5, // change this number to adjust width/height ratio of the grid items
                    ),
                    itemBuilder: (context, index) {
                      var answer = exerciseData.result![currentQuestionIndex].answers![index];
                      return Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _determineBorderColor(answer.yourChoice, answer.isTrue),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('${answerLabels[index]}: ${answer.name ?? 'No name'}'),

                      );
                    },

                  )
                      : ListView(
                    children: [
                      if (exerciseData.result![currentQuestionIndex].answers!.yourInputs!.isNotEmpty)
                        Text('Your inputs: ${exerciseData.result![currentQuestionIndex].answers!.yourInputs!.join(', ')}'),
                      if (exerciseData.result![currentQuestionIndex].answers!.corrects!.isNotEmpty)
                        Text('Correct answers: ${exerciseData.result![currentQuestionIndex].answers!.corrects!.join(', ')}'),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Is correct: ${exerciseData.result![currentQuestionIndex].answers!.correct! ? 'Yes' : 'No'}',
                          style: TextStyle(
                            color: exerciseData.result![currentQuestionIndex].answers!.correct! ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (currentQuestionIndex > 0)
              ElevatedButton(
                child: Text('Previous'),
                onPressed: () {
                  setState(() {
                    currentQuestionIndex--;
                  });
                },
              ),
            ElevatedButton(
              child: Text('Next'),
              onPressed: exerciseData != null &&
                  currentQuestionIndex < exerciseData.result!.length - 1
                  ? () {
                setState(() {
                  currentQuestionIndex++;
                });
              }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}