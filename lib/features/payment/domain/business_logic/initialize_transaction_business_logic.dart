import 'package:legwork/features/payment/domain/entities/payment_entity.dart';
import 'package:legwork/features/payment/domain/repo/payment_repo.dart';

class InitTransactionBusinessLogic {
  final PaymentRepo repo;

  InitTransactionBusinessLogic({required this.repo});

  Future<PaymentEntity> execute({
    required double amount,
    required String email,
    required String dancerId,
    required String clientId,
  }) async {
    return await repo.initializeTransaction(
      amount: amount,
      email: email,
      dancerId: dancerId,
      clientId: clientId,
    );
  }
}
