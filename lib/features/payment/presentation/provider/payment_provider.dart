import 'package:flutter/material.dart';
import 'package:legwork/features/payment/domain/business_logic/initialize_transaction_business_logic.dart';
import 'package:legwork/features/payment/domain/business_logic/verify_transaction_business_logic.dart';
import 'package:legwork/features/payment/domain/entities/payment_entity.dart';

class PaymentProvider extends ChangeNotifier {
  final InitTransactionBusinessLogic initTransactionBusinessLogic;
  final VerifyTransactionBusinessLogic verifyTransactionBusinessLogic;

  // Constructor
  PaymentProvider({
    required this.initTransactionBusinessLogic,
    required this.verifyTransactionBusinessLogic,
  });

  PaymentEntity? _payment;
  PaymentEntity? get payment => _payment;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // INITIALIZE PAYMENT
  Future<void> initPayment({
    required double amount,
    required String email,
    required String dancerId,
    required String clientId,
  }) async {
    _isLoading = true;
    _error = null;
    // notifyListeners();

    try {
      _payment = await initTransactionBusinessLogic.execute(
        amount: amount,
        email: email,
        dancerId: dancerId,
        clientId: clientId,
      );
    } catch (e) {
      _payment = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // VERIFY PAYMENT
  Future<void> verifyPayment({required String reference}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _payment = await verifyTransactionBusinessLogic.execute(
        reference: reference,
      );
    } catch (e) {
      _payment = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
