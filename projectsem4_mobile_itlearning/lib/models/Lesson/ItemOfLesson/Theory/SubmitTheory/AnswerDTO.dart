class AnswerDTO {
  String name;
  bool isChoice;

  AnswerDTO({required this.name, required this.isChoice});

  factory AnswerDTO.fromJson(Map<String, dynamic> json) {
    return AnswerDTO(
      name: json['name'],
      isChoice: json['isChoice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isChoice': isChoice,
    };
  }
}