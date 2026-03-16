/// Entité représentant une livraison de message à un destinataire.
class DeliveryEntity {
  final String id;
  final String messageId;
  final String receiverId;
  final DateTime deliveredAt;

  const DeliveryEntity({
    required this.id,
    required this.messageId,
    required this.receiverId,
    required this.deliveredAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
