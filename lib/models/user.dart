import 'store.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String phoneNumber;
  final String city;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Store store;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.phoneNumber,
    required this.city,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
    required this.store,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      phoneNumber: json['phone_number'],
      city: json['city'] ?? '',
      roleId: json['role_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      store: Store.fromJson(json['store']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone_number': phoneNumber,
      'city': city,
      'role_id': roleId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'store': store.toJson(),
    };
  }
}
