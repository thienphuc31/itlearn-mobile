class NoteInDurationDTO {
  final int duration;
  final String content;
  final int videoCourseId;

  NoteInDurationDTO({required this.duration, required this.content, required this.videoCourseId});

  factory NoteInDurationDTO.fromJson(Map<String, dynamic> json) {
    return NoteInDurationDTO(
      duration: json['duration'],
      content: json['content'],
      videoCourseId: json['videoCourseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'content': content,
      'videoCourseId': videoCourseId,
    };
  }
}