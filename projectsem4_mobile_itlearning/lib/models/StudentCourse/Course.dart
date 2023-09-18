class Course {
   int? id;
   String? title;
   List<String>? arrayLanguageIcon;
   int? totalVideo;
   int? totalTheory;
   int? totalExercise;
   int? totalCompletedVideo;
   int? totalCompletedTheory;
   int? totalCompletedExercise;
   String? dateStart;
   String? dateEnd;
   int? percentVideo;
   int? percentTheory;
   int? percentExercise;

  Course({
     this.id,
     this.title,
     this.arrayLanguageIcon,
     this.totalVideo,
     this.totalTheory,
     this.totalExercise,
     this.totalCompletedVideo,
     this.totalCompletedTheory,
     this.totalCompletedExercise,
     this.dateStart,
     this.dateEnd,
     this.percentVideo,
     this.percentTheory,
     this.percentExercise,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      arrayLanguageIcon: List<String>.from(json['arrayLanguageIcon']),
      totalVideo: json['totalVideo'],
      totalTheory: json['totalTheory'],
      totalExercise: json['totalExercise'],
      totalCompletedVideo: json['totalCompletedVideo'],
      totalCompletedTheory: json['totalCompletedTheory'],
      totalCompletedExercise: json['totalCompletedExercise'],
      dateStart: json['dateStart'],
      dateEnd: json['dateEnd'],
      percentVideo: json['percentVideo'],
      percentTheory: json['percentTheory'],
      percentExercise: json['percentExercise'],
    );
  }
}