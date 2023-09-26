class NoteInVideoDTO {
  int? id;
  String? content;
  int? duration;
  String? createdAt;
  String? updatedAt;

  NoteInVideoDTO({this.id, this.content, this.duration, this.createdAt, this.updatedAt});

  NoteInVideoDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    duration = json['duration'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['duration'] = this.duration;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
