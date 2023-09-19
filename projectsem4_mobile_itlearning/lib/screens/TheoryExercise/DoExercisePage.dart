import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../../models/Lesson/ItemOfLesson/Theory/SubmitTheory/AnswerDTO.dart';
import '../../models/Lesson/ItemOfLesson/Theory/SubmitTheory/QuestionSubmitDTO.dart';
import '../../providers/ExerciseProvider.dart';

class DoExercisePage extends StatefulWidget {
  @override
  _DoExercisePageState createState() => _DoExercisePageState();
}

class _DoExercisePageState extends State<DoExercisePage> {
  int currentQuestionIndex = 0;
  final answerLabels = ['A', 'B', 'C', 'D'];
  List<QuestionSubmitDTO> questionSubmitDTOs = [];
  ExerciseData? exerciseData;
  late List<TextEditingController> _controllers;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      exerciseData = Provider.of<ExerciseProvider>(context, listen: false)
          .submittedExerciseData;
      setState(() {
        questionSubmitDTOs = exerciseData!.questions!.map((question) {
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
            (index) => TextEditingController(),
      );
    });
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  String _getQuestionTypeDescription(String typeQuestion) {
    switch (typeQuestion) {
      case 'SINGLE_CHOICE':
        return 'Chọn 1 đáp án đúng';
      case 'MULTIPLE_CHOICE':
        return 'Chọn những đáp án đúng';
      case 'WRITE_FILL_BLANK':
        return 'Điền vào chỗ trống';
      default:
        return 'Kiểu câu hỏi không xác định';
    }
  }



  List<Widget> _buildQuestionWithInputs(String questionContent, int questionIndex) {
    var splitQuestion = questionContent.split('_blank_');
    List<Widget> widgets = [];

    for (var i = 0; i < splitQuestion.length; i++) {
      widgets.add(Text(splitQuestion[i]));
      if (i != splitQuestion.length - 1) {
        widgets.add(TextField(
          controller: _controllers[i],
          onChanged: (value) {
            setState(() {
              questionSubmitDTOs[currentQuestionIndex].answers[i].name = value[i];
            });
          },
          decoration: InputDecoration(hintText: 'Enter your answer here'),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    print("aa");
    return Scaffold(
      appBar: AppBar(
        title: Text('Do Exercises'),
      ),
      body: Column(
        children: <Widget>[
          if (exerciseData != null &&
              exerciseData!.questions != null &&
              exerciseData!.questions!.length > currentQuestionIndex)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Câu ${currentQuestionIndex + 1}: ${_getQuestionTypeDescription(exerciseData!.questions![currentQuestionIndex].typeQuestion!)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    currentQuestionIndex
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
              if (currentQuestionIndex == exerciseData!.questions!.length - 1)
                ElevatedButton(
                  child: Text('Nộp bài'),
                  onPressed: () {
                    // Handle submission logic here
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
