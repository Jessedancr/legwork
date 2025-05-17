import 'package:legwork/features/payment/domain/entities/payment_entity.dart';
import 'package:legwork/features/payment/domain/repo/payment_repo.dart';

class GetClientTransactionsBusinessLogic {
  final PaymentRepo repo;

  GetClientTransactionsBusinessLogic({required this.repo});

  Future<List<PaymentEntity>> execute({required String clientId}) async {
    return await repo.getClientTransactions(clientId: clientId);
  }
}
