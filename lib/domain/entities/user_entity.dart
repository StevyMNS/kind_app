/// Entité représentant un utilisateur.
class UserEntity {
  final String id;
  final DateTime createdAt;

  const UserEntity({required this.id, required this.createdAt});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserEntity(id: $id)';
}
