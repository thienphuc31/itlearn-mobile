class Lesson {
  final int? id;
  final String? title;
  final String? urlDocument;
  final List<ItemOfLesson>? itemOfLessons;

  Lesson({this.id, this.title, this.urlDocument, this.itemOfLessons});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var list = json['itemOfLessons'] as List;
    List<ItemOfLesson> itemOfLessonList = list.map((i) => ItemOfLesson.fromJson(i)).toList();

    return Lesson(
      id: json['id'],
      title: json['title'],
      urlDocument: json['urlDocument'],
      itemOfLessons: itemOfLessonList,
    );
  }
}

class ItemOfLesson {
  final int? id;
  final String? type;
  final String? title;
  final String? urlDocument;
  final VideoCourse? videoCourse;
  final TheoryExercise? theoryExercise;
  final ExerciseHome? exerciseHome;
  final bool? complete;

  ItemOfLesson({this.id, this.type, this.title, this.urlDocument, this.videoCourse, this.theoryExercise, this.exerciseHome, this.complete});

  factory ItemOfLesson.fromJson(Map<String, dynamic> json) {
    return ItemOfLesson(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      urlDocument: json['urlDocument'],
      videoCourse: json['videoCourse'] != null && json['videoCourse'] is Map<String, dynamic> ? VideoCourse.fromJson(json['videoCourse']) : null,
      theoryExercise: json['theoryExercise'] != null && json['theoryExercise'] is Map<String, dynamic> ? TheoryExercise.fromJson(json['theoryExercise']) : null,
      exerciseHome: json['exerciseHome'] != null && json['exerciseHome'] is Map<String, dynamic> ? ExerciseHome.fromJson(json['exerciseHome']) : null,
      complete: json['complete'],
    );
  }
}

class VideoCourse {
  final int? id;
  final String? urlVideo;
  final int? duration;

  VideoCourse({this.id, this.urlVideo, this.duration});

  factory VideoCourse.fromJson(Map<String, dynamic> json) {
    return VideoCourse(
      id: json['id'],
      urlVideo: json['urlVideo'],
      duration: json['duration'],
    );
  }
}

class TheoryExercise {
  final int? id;
  final String? name;

  TheoryExercise({this.id, this.name});

  factory TheoryExercise.fromJson(Map<String, dynamic> json) {
    return TheoryExercise(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ExerciseHome {
  final int? id;
  final String? urlDocument;
  final String? description;
  final int? mark;
  final bool? submited;
  final String? yourUrlDocument;
  final String? mentorDescription;
  final bool? marked;

  ExerciseHome({this.id, this.urlDocument, this.description, this.mark, this.submited, this.yourUrlDocument, this.mentorDescription, this.marked});

  factory ExerciseHome.fromJson(Map<String, dynamic> json) {
    return ExerciseHome(
      id: json['id'],
      urlDocument: json['urlDocument'],
      description: json['description'],
      mark: json['mark'],
      submited: json['submited'],
      yourUrlDocument: json['yourUrlDocument'],
      mentorDescription: json['mentorDescription'],
      marked: json['marked'],
    );
  }
}