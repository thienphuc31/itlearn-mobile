class CourseKey {
  final int? id;
  final String? title;
  final String? thumbnail;
  final int? totalVideo;
  final int? totalTheory;
  final int? totalExercise;
  final int? percentCompleted;
  final bool? allowAccess;

  CourseKey({
    this.id,
    this.title,
    this.thumbnail,
    this.totalVideo,
    this.totalTheory,
    this.totalExercise,
    this.percentCompleted,
    this.allowAccess
  });

  factory CourseKey.fromJson(Map<String, dynamic> json) {
    return CourseKey(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      totalVideo: json['totalVideo'],
      totalTheory: json['totalTheory'],
      totalExercise: json['totalExercise'],
      percentCompleted: json['percentCompleted'],
      allowAccess: json['allowAccess']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'totalVideo': totalVideo,
      'totalTheory': totalTheory,
      'totalExercise': totalExercise,
      'percentCompleted': percentCompleted,
      'allowAccess': allowAccess
    };
  }
}