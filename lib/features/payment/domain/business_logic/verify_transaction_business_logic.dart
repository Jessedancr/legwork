import 'package:legwork/features/payment/domain/entities/payment_entity.dart';
import 'package:legwork/features/payment/domain/repo/payment_repo.dart';

class VerifyTransactionBusinessLogic {
  final PaymentRepo repo;

  VerifyTransactionBusinessLogic({required this.repo});

  Future<PaymentEntity> execute({required String reference}) async {
    return await repo.verifyTransaction(reference: reference);
  }
}
