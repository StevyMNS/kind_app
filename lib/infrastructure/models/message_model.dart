import 'package:kind_app/domain/entities/message_entity.dart';

/// DTO pour un message (sérialisation/désérialisation Supabase).
class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'sender_id': senderId, 'content': content};
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      content: content,
      createdAt: createdAt,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      senderId: entity.senderId,
      content: entity.content,
      createdAt: entity.createdAt,
    );
  }
}
