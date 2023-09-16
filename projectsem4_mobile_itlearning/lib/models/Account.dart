import 'dart:convert';

class Account {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String education;
  final String? cardBefore;
  final String? cardAfter;
  final String username;
  final int positive;
  final int level;
  final int experience;
  final int coin;
  final String rank;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String dob;
  final String avatar;

  Account({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.education,
    this.cardBefore,
    this.cardAfter,
    required this.username,
    required this.positive,
    required this.level,
    required this.experience,
    required this.coin,
    required this.rank,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.dob,
    required this.avatar,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] ?? 0,
      fullName: map['fullName'] ?? "null",
      email: map['email'] ?? "null",
      phone: map['phone'] ?? "null",
      address: map['address'] ?? "null",
      education: map['education']?? "null",
      cardBefore: map['cardBefore'],
      cardAfter: map['cardAfter'],
      username: map['username'] ?? "null",
      positive: map['positive'] ?? 0,
      level: map['level'] ?? 0,
      experience: map['experience'] ?? 0,
      coin: map['coin'] ?? 0,
      rank: map['rank'] ?? "null",
      status: map['status'] ?? "null",
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      dob: map['dob'] ?? "null",
      avatar: map['avatar'] ?? "null",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'education': education,
      'cardBefore': cardBefore,
      'cardAfter': cardAfter,
      'username': username,
      'positive': positive,
      'level': level,
      'experience': experience,
      'coin': coin,
      'rank': rank,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dob': dob,
      'avatar': avatar,
    };
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));
}
