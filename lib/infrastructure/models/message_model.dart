import 'package:kind_app/domain/entities/message_entity.dart';

/// DTO pour un message (sérialisation/désérialisation Supabase).
class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final String? senderCountryCode;
  final String? senderCountryEmoji;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    this.senderCountryCode,
    this.senderCountryEmoji,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      senderCountryCode: json['sender_country_code'] as String?,
      senderCountryEmoji: json['sender_country_emoji'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'content': content,
      'sender_country_code': senderCountryCode,
      'sender_country_emoji': senderCountryEmoji,
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      content: content,
      senderCountryCode: senderCountryCode,
      senderCountryEmoji: senderCountryEmoji,
      createdAt: createdAt,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      senderId: entity.senderId,
      content: entity.content,
      senderCountryCode: entity.senderCountryCode,
      senderCountryEmoji: entity.senderCountryEmoji,
      createdAt: entity.createdAt,
    );
  }
}
