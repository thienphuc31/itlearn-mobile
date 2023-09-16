class CategoryCourseDto {
  int id;
  String name;
  String slug;

  CategoryCourseDto({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryCourseDto.fromJson(Map<String, dynamic> json) {
    return CategoryCourseDto(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}
