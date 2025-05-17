import 'package:legwork/features/payment/data/data_sources/payment_remote_data_source.dart';
import 'package:legwork/features/payment/domain/entities/payment_entity.dart';
import 'package:legwork/features/payment/domain/repo/payment_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  final PaymentRemoteDataSource paymentRemoteDataSource;

  // Constructor
  PaymentRepoImpl({required this.paymentRemoteDataSource});
  @override
  Future<PaymentEntity> initializeTransaction({
    required double amount,
    required String email,
    required String dancerId,
    required String clientId,
  }) async {
    return await paymentRemoteDataSource.initializeTransaction(
      amount: amount,
      email: email,
      dancerId: dancerId,
      clientId: clientId,
    );
  }

  @override
  Future<PaymentEntity> verifyTransaction({
    required String reference,
  }) async {
    return await paymentRemoteDataSource.verifyTransaction(
      reference: reference,
    );
  }

  @override
  Future<List<PaymentEntity>> getClientTransactions({
    required String clientId,
  }) async {
    return await paymentRemoteDataSource.getClientTransactions(
      clientId: clientId,
    );
  }
}
