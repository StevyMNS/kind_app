import 'package:kind_app/domain/entities/delivery_entity.dart';

/// DTO pour une livraison de message (sérialisation/désérialisation Supabase).
class DeliveryModel {
  final String id;
  final String messageId;
  final String receiverId;
  final DateTime deliveredAt;

  const DeliveryModel({
    required this.id,
    required this.messageId,
    required this.receiverId,
    required this.deliveredAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as String,
      messageId: json['message_id'] as String,
      receiverId: json['receiver_id'] as String,
      deliveredAt: DateTime.parse(json['delivered_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message_id': messageId, 'receiver_id': receiverId};
  }

  DeliveryEntity toEntity() {
    return DeliveryEntity(
      id: id,
      messageId: messageId,
      receiverId: receiverId,
      deliveredAt: deliveredAt,
    );
  }
}
