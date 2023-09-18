import 'dart:convert';
class ExerciseData {
  int? id;
  String? name;
  List<Question>? questions;
  int? mark;
  String? dateStart;
  String? dateSubmit;
  String? expiredDate;
  List<Result>? result;
  String? status;

  ExerciseData(
      {this.id,
        this.name,
        this.questions,
        this.mark,
        this.dateStart,
        this.dateSubmit,
        this.expiredDate,
        this.result,
        this.status});

  ExerciseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
    mark = json['mark'];
    dateStart = json['dateStart'];
    dateSubmit = json['dateSubmit'];
    expiredDate = json['expiredDate'];
    if (json['result'] != null) {
      result = <Result>[];
      jsonDecode(json['result']).forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['questions'] = this.questions;
    data['mark'] = this.mark;
    data['dateStart'] = this.dateStart;
    data['dateSubmit'] = this.dateSubmit;
    data['expiredDate'] = this.expiredDate;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Result {
  String? typeQuestion;
  String? questionContent;
  int? mark;
  dynamic answers;

  Result({this.typeQuestion, this.questionContent, this.mark, this.answers});

  Result.fromJson(Map<String, dynamic> json) {
    typeQuestion = json['typeQuestion'];
    questionContent = json['questionContent'];
    mark = json['mark'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      if(typeQuestion != "WRITE_FILL_BLANK"){
        json['answers'].forEach((v) {
          answers!.add(new Answers.fromJson(v));
        });
      }else{
        answers = FillBlankAnswer.fromJson(json['answers']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeQuestion'] = this.typeQuestion;
    data['questionContent'] = this.questionContent;
    data['mark'] = this.mark;
    // To json answers
    return data;
  }
}

class Answers {
  String? name;
  bool? yourChoice;
  bool? isTrue;

  Answers({this.name, this.yourChoice, this.isTrue});

  Answers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    yourChoice = json['yourChoice'];
    isTrue = json['true'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['yourChoice'] = this.yourChoice;
    data['true'] = this.isTrue;
    return data;
  }
}

// Class representing the Fill Blank Answer data
class FillBlankAnswer {
  List<String>? corrects;
  List<String>? yourInputs;
  bool? correct;

  FillBlankAnswer({
    this.corrects,
    this.yourInputs,
    this.correct,
  });

  // Factory method to create an instance of FillBlankAnswer from JSON data
  factory FillBlankAnswer.fromJson(Map<String, dynamic> json) {
    return FillBlankAnswer(
      corrects: _convertToListOfString(json['corrects']),
      yourInputs: _convertToListOfString(json['yourInputs']),
      correct: json['correct'] as bool?,
    );
  }

  // Helper method to convert list of dynamic to list of String
  static List<String>? _convertToListOfString(List<dynamic>? list) {
    return list?.cast<String>();
  }
}

// Class representing the Answer Result data
class AnswerResult {
  String? name;
  bool? yourChoice;
  bool? correct;

  AnswerResult({
    this.name,
    this.yourChoice,
    this.correct,
  });

  // Factory method to create an instance of AnswerResult from JSON data
  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      name: json['name'] as String?,
      yourChoice: json['yourChoice'] as bool?,
      correct: json['correct'] as bool?,
    );
  }
}

// Class representing the Question data
class Question {
  int? id;
  String? typeQuestion;
  String? questionContent;
  List<Answer>? answersClient;
  int? mark;

  Question({
    this.id,
    this.typeQuestion,
    this.questionContent,
    this.answersClient,
    this.mark,
  });

  // Factory method to create an instance of Question from JSON data
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int?,
      typeQuestion: json['typeQuestion'] as String?,
      questionContent: json['questionContent'] as String?,
      answersClient: _convertToAnswerList(json['answersClient'] as List?),
      mark: json['mark'] as int?,
    );
  }

  // Helper method to convert list of dynamic to list of Answer
  static List<Answer>? _convertToAnswerList(List<dynamic>? list) {
    return list?.map((item) => Answer.fromJson(item)).toList();
  }
}

// Class representing the Answer data
class Answer {
  String? name;

  Answer({this.name});

  // Factory method to create an instance of Answer from JSON data
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      name: json['name'] as String?,
    );
  }
}