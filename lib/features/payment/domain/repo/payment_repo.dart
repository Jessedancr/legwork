import 'package:legwork/features/payment/domain/entities/payment_entity.dart';

abstract class PaymentRepo {
  Future<PaymentEntity> initializeTransaction({
    required double amount,
    required String email,
    required String dancerId,
    required String clientId,
  });

  Future<PaymentEntity> verifyTransaction({required String reference});

  Future<List<PaymentEntity>> getClientTransactions({required String clientId});
}
