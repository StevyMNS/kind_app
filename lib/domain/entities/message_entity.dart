/// Entité représentant un message bienveillant.
class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MessageEntity(id: $id, content: ${content.substring(0, content.length > 20 ? 20 : content.length)}...)';
}
