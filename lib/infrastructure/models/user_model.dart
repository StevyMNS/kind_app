import 'package:kind_app/domain/entities/user_entity.dart';

/// DTO pour l'utilisateur (sérialisation/désérialisation Supabase).
class UserModel {
  final String id;
  final DateTime createdAt;

  const UserModel({required this.id, required this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'created_at': createdAt.toIso8601String()};
  }

  UserEntity toEntity() {
    return UserEntity(id: id, createdAt: createdAt);
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(id: entity.id, createdAt: entity.createdAt);
  }
}
