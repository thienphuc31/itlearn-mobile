import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../../models/Lesson/ItemOfLesson/Theory/SubmitTheory/AnswerDTO.dart';
import '../../models/Lesson/ItemOfLesson/Theory/SubmitTheory/QuestionSubmitDTO.dart';
import '../../models/Lesson/ItemOfLesson/Theory/SubmitTheory/SubmitTheoryExerciseDTO.dart';
import '../../providers/ExerciseProvider.dart';
import '../../widgets/CountdownTimerWidget.dart';

class DoExercisePage extends StatefulWidget {
  @override
  _DoExercisePageState createState() => _DoExercisePageState();
}

class _DoExercisePageState extends State<DoExercisePage> {
  int currentQuestionIndex = 0;
  final answerLabels = ['A', 'B', 'C', 'D'];
  List<QuestionSubmitDTO> questionSubmitDTOs = [];
  ExerciseData? exerciseData;
  List<List<TextEditingController>> _controllers = [];
  late Duration remaining = remainingTime();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      exerciseData = Provider.of<ExerciseProvider>(context, listen: false)
          .submittedExerciseData!;
      setState(() {
        questionSubmitDTOs = exerciseData!.questions!.map((question ) {
          int numberInput = question.questionContent!.split("_blank_").length - 1;
          return QuestionSubmitDTO(
            questionId: question!.id!,
            answers: question.typeQuestion != "WRITE_FILL_BLANK"
                ? question.answersClient!.map((answerClient) {
              return AnswerDTO(name: answerClient.name!, isChoice: false);
            }).toList()
                : List.filled(numberInput, AnswerDTO(name: "")),
          );
        }).toList(growable: true);
      });

      _controllers = List.generate(
        exerciseData!.questions!.length,
            (index) => List.generate(
          exerciseData!.questions![index].questionContent!.split("_blank_").length - 1,
              (index) => TextEditingController(),
        ),
      );
    });

  }

  bool isExpired() {
    DateTime currentDateTime = DateTime.now();
    DateTime expiredDateTime = DateTime.parse(exerciseData!.expiredDate!);
    return expiredDateTime.isBefore(currentDateTime);
  }


  Duration remainingTime() {
    DateTime currentDateTime = DateTime.now();
    DateTime expiredDateTime = DateTime.parse(exerciseData!.expiredDate!);

    if (expiredDateTime.isBefore(currentDateTime)) {
      return Duration.zero;
    }

    return expiredDateTime.difference(currentDateTime);
  }

  autoSubmit() async {
    late SubmitTheoryExerciseDTO submitExerciseData = SubmitTheoryExerciseDTO(questions: questionSubmitDTOs);
    await Provider.of<ExerciseProvider>(context, listen: false)
        .submitTheoryExercise(exerciseData!.id!, submitExerciseData);
    Navigator.pushNamed(context, '/Main');
  }
  @override
  void dispose() {


    super.dispose();
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





  final _logger = Logger('QuestionInput');
  final List<String> _inputValues = [];
  final List<AnswerDTO> _blankValues = [];
  final List<QuestionSubmitDTO> _blankValuesList = [];

  List<Widget> _buildQuestionWithInputs(String questionContent, int questionIndex, String questionType, int questionId) {
    var splitQuestion = questionContent.split('_blank_');
    List<Widget> widgets = [];
    _logger.info('Number of blanks: ${splitQuestion.length}');
    // if(splitQuestion.length > 0){
    //   updateAnswers(questionIndex);
    // }
    for (int i = 0; i < splitQuestion.length; i++) {
      widgets.add(Text(splitQuestion[i]));

      if (i != splitQuestion.length - 1) {
        // Initialize the corresponding value in the list.
        if (_inputValues.length <= i) {
          _inputValues.add('');
        }

        widgets.add(TextField(
          controller: _controllers[questionIndex][i],
          onChanged: (value) {
            // Store the value in the list.
            _inputValues[i] = value;

            _blankValues.clear();

            // Create a new AnswerDTO for each input value and add it to _blankValues.
            for (var input in _inputValues) {
              _blankValues.add(AnswerDTO(name: input));
            }

            var newQuestionSubmitDTO = QuestionSubmitDTO(questionId: questionId, answers: _blankValues);

            // Check if a QuestionSubmitDTO with the same questionId exists.
            int index = _blankValuesList.indexWhere((q) => q.questionId == questionId);

            // If a QuestionSubmitDTO with the same questionId exists, replace it. Otherwise, add the new one.
            if (index != -1) {
              _blankValuesList[index] = newQuestionSubmitDTO;
            } else {
              _blankValuesList.add(newQuestionSubmitDTO);
            }

            // Log all current input values and AnswerDTOs.
            _logger.info('Current input values: $_inputValues');
            _logger.info('Current AnswerDTOs: ${_blankValues.map((e) => e.toJson()).toList()}');
          },
          decoration: InputDecoration(hintText: 'Enter your answer here'),
        ));
      }
    }


    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    print("aaa");
    return FutureBuilder(
      future: Provider.of<ExerciseProvider>(context, listen: false).getSubmittedExerciseData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('An error occurred!'));
        } else if (snapshot.data == null) {
          return Center(child: Text('No data available!'));
        } else {
          // Use the fetched data
          exerciseData = snapshot.data!;

          return Scaffold(
              resizeToAvoidBottomInset:false,
            appBar: AppBar(
              title:  Text('Do Exercises: ${exerciseData!.name}'),
              backgroundColor: primaryBlue,
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  if (exerciseData != null &&
                      exerciseData!.questions != null &&
                      exerciseData!.questions!.length > currentQuestionIndex)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Câu ${currentQuestionIndex + 1}: ${_getQuestionTypeDescription(exerciseData!.questions![currentQuestionIndex].typeQuestion!)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                          ),
                          CountdownTimerWidget(
                            initialDuration: remainingTime(),  // Replace with your remaining time function
                            onTimeout: autoSubmit,  // Replace with your auto submit function
                          ),
                        ],
                      ),
                    ),
                  if (exerciseData != null &&
                      exerciseData!.questions!.length > currentQuestionIndex)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: _buildQuestionWithInputs(
                            exerciseData!.questions![currentQuestionIndex].questionContent!,
                            currentQuestionIndex, exerciseData!
                            .questions![currentQuestionIndex].typeQuestion!, exerciseData!
                            .questions![currentQuestionIndex].id!
                        ),
                      ),
                    ),
                  if (exerciseData != null &&
                      exerciseData!.questions != null &&
                      exerciseData!.questions!.length > currentQuestionIndex)
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        child: exerciseData!
                            .questions![currentQuestionIndex].typeQuestion !=
                            "WRITE_FILL_BLANK"
                            ? (exerciseData!.questions![currentQuestionIndex]
                            .answersClient !=
                            null
                            ? GridView.builder(
                          itemCount: exerciseData!
                              .questions![currentQuestionIndex]
                              .answersClient!
                              .length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5,
                          ),
                          itemBuilder: (context, index) {
                            var answer = exerciseData!
                                .questions![currentQuestionIndex]
                                .answersClient![index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (exerciseData!
                                      .questions![currentQuestionIndex]
                                      .typeQuestion ==
                                      "SINGLE_CHOICE") {
                                    // Set all isChoice to false
                                    for (var answerDTO in questionSubmitDTOs[
                                    currentQuestionIndex]
                                        .answers) {
                                      answerDTO.isChoice = false;
                                    }
                                    // Set the selected one to true
                                    questionSubmitDTOs[currentQuestionIndex]
                                        .answers[index]
                                        .isChoice = true;
                                  } else {
                                    // If it's not a SINGLE_CHOICE question, toggle the current choice
                                    questionSubmitDTOs[currentQuestionIndex]
                                        .answers[index]
                                        .isChoice = !questionSubmitDTOs[
                                    currentQuestionIndex]
                                        .answers[index]
                                        .isChoice!;
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: questionSubmitDTOs[
                                    currentQuestionIndex]
                                        .answers[index]
                                        .isChoice ==
                                        false
                                        ? Colors.black
                                        : Colors.green,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                    '${answerLabels[index]}: ${questionSubmitDTOs[currentQuestionIndex].answers[index].name ?? 'Không có tên'}'),
                              ),
                            );
                          },
                        )
                            : Container())
                            : Container(),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // adjusts the spacing between buttons
                    children: <Widget>[
                      if (currentQuestionIndex > 0)
                        ElevatedButton(
                          child: Text('Câu trước'),
                          onPressed: () {
                            setState(() {
                              currentQuestionIndex--;
                            });
                          },
                        ),
                      ElevatedButton(
                        child: Text('Câu sau'),
                        onPressed: exerciseData != null &&
                            exerciseData!.questions != null &&
                            currentQuestionIndex < exerciseData!.questions!.length - 1
                            ? () {
                          setState(() {
                            currentQuestionIndex++;
                          });
                        }
                            : null,
                      ),
                      if (exerciseData != null &&
                          exerciseData!.questions != null &&
                          currentQuestionIndex == exerciseData!.questions!.length - 1)
                        ElevatedButton(
                          child: Text('Nộp bài'),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Xác nhận'),
                                  content: Text('Bạn có chắc chắn muốn nộp bài không?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Hủy'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Nộp bài'),
                                      onPressed: () async {
                                        late SubmitTheoryExerciseDTO submitExerciseData = SubmitTheoryExerciseDTO(questions: questionSubmitDTOs);
                                        for(int i = 0; i< _controllers.length; i++){
                                          var questionContoller = _controllers[i];
                                          var questionOrigin = questionSubmitDTOs[i];
                                          if(_controllers[i].length != 0){
                                            questionOrigin.answers = questionContoller.map((input) => AnswerDTO(name: input.text)).toList();
                                          }
                                        }
                                        await Provider.of<ExerciseProvider>(context, listen: false)
                                            .submitTheoryExercise(exerciseData!.id!, submitExerciseData);
                                        Navigator.of(context).pop();
                                        Navigator.pushNamed(context, '/Main');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );



  }
}



