class AnswerDTO {
  String name;
  bool? isChoice;

  AnswerDTO({required this.name, this.isChoice});

  factory AnswerDTO.fromJson(Map<String, dynamic> json) {
    return AnswerDTO(
      name: json['name'],
      isChoice: json['choice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // chỉ thêm isChoice vào JSON nếu nó không phải là null
      if (isChoice != null) 'choice': isChoice,
    };
  }
}