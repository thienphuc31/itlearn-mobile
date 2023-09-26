import 'dart:convert';

class Account {
  Account({
      required this.name,});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name
    };
  }
  String name;

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        name: map['name'] as String,
    );}

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source) as Map<String, dynamic>);
}