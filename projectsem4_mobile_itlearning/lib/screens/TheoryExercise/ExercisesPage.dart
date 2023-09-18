import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/Lesson/ItemOfLesson/Theory/ExerciseData.dart';

class ExercisesPage extends StatelessWidget {
  final List<ExerciseData> exercises;

  ExercisesPage({required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(exercises[i].questions!.map((q) => q.questionContent).join(", ")), // Assuming `questionText` is a field in your `Question` model
          // Add more fields of ExerciseData as needed
        ),
      ),
    );
  }
}