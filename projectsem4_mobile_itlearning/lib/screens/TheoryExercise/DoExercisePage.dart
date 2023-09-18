

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';
import '../../providers/ExerciseProvider.dart';

class DoExercisePage extends StatefulWidget {
  @override
  _DoExercisePageState createState() => _DoExercisePageState();
}

class _DoExercisePageState extends State<DoExercisePage> {
  int currentQuestionIndex = 0;
  final answerLabels = ['A', 'B', 'C', 'D'];

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

  @override
  Widget build(BuildContext context) {
    ExerciseData? exerciseData = Provider.of<ExerciseProvider>(context).submittedExerciseData;
    print("a");
    return Scaffold(
      appBar: AppBar(
        title: Text('Do Exercises'),
      ),
      body: Column(
        children: <Widget>[
          if (exerciseData != null && exerciseData.questions != null && exerciseData.questions!.length > currentQuestionIndex)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Câu ${currentQuestionIndex + 1}: ${_getQuestionTypeDescription(exerciseData.questions![currentQuestionIndex].typeQuestion!)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (exerciseData != null && exerciseData.questions != null && exerciseData.questions!.length > currentQuestionIndex)
            Expanded(
              child: Container(
                child: exerciseData.questions![currentQuestionIndex].typeQuestion != "WRITE_FILL_BLANK"
                    ? (exerciseData.questions![currentQuestionIndex].answersClient != null
                    ? GridView.builder(
                  itemCount: exerciseData.questions![currentQuestionIndex].answersClient!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:3.5,
                  ),
                  itemBuilder: (context, index) {
                    var answer = exerciseData.questions![currentQuestionIndex].answersClient![index];
                    return GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('${answerLabels[index]}: ${answer.name ?? 'Không có tên'}'),
                      ),
                    );
                  },
                )
                    : Container())
                    : TextField(
                  decoration: InputDecoration(
                    hintText: 'Nhập câu trả lời của bạn vào đây',
                  ),
                  onChanged: (value) {
                    // handle the user's text input here
                    // this is where you'd typically update the user's entered text
                  },
                ),
              ),
            ),
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
            onPressed: exerciseData != null && exerciseData.questions != null && currentQuestionIndex < exerciseData.questions!.length - 1
                ? () {
              setState(() {
                currentQuestionIndex++;
              });
            }
                : null,
          ),
        ],
      ),
    );
  }
}