import 'AnswerDTO.dart';

class QuestionSubmitDTO {
  int questionId;
  List<AnswerDTO> answers;

  QuestionSubmitDTO({required this.questionId, required this.answers});

  factory QuestionSubmitDTO.fromJson(Map<String, dynamic> json) {
    return QuestionSubmitDTO(
      questionId: json['questionId'],
      answers: (json['answers'] as List)
          .map((i) => AnswerDTO.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}