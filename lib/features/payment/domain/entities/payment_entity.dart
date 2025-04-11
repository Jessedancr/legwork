class PaymentEntity {
  final String reference;
  final double amount;
  final String email;
  final String dancerId;
  final String clientId;
  final DateTime? createdAt;
  final String? status;

  PaymentEntity({
    required this.reference,
    required this.amount,
    required this.email,
    required this.dancerId,
    required this.clientId,
    this.createdAt,
    this.status,
  });
}