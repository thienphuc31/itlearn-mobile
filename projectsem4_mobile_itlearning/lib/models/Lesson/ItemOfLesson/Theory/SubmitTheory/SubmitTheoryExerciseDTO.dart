import 'QuestionSubmitDTO.dart';

class SubmitTheoryExerciseDTO {
  List<QuestionSubmitDTO> questions;

  SubmitTheoryExerciseDTO({required this.questions});

  factory SubmitTheoryExerciseDTO.fromJson(Map<String, dynamic> json) {
    return SubmitTheoryExerciseDTO(
      questions: (json['questions'] as List)
          .map((i) => QuestionSubmitDTO.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}