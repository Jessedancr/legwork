import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:legwork/core/network/online_payment_info.dart';
import 'package:legwork/features/payment/domain/entities/payment_entity.dart';

class PaymentRemoteDataSource {
  final OnlinePaymentInfo onlinePaymentInfo;

  PaymentRemoteDataSource({required this.onlinePaymentInfo});

  // SUB ACCOUNTS
  Future<void> createSubAccount({
    required String acctName,
    required String acctNum,
    required String bankName,
  }) async {
    try {
      final response =
          await onlinePaymentInfo.post(endpoint: '/subaccount', body: {
        "acctName": acctName,
        "banckName": bankName, // e.g. from Paystack's bank list
        "acctNum": acctNum,
        "description": "Dancer payout account"
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data == null) {
          debugPrint('Invalid response from paystack: ${data.toString()}');
          throw Exception('Invalid response from paystack');
        }
        return data;
      } else {
        throw Exception('Failed to create sub account');
      }
    } catch (e) {
      debugPrint('Unexpected error with creating sub account');
      throw Exception(
          'Unexpected error with creating sub account: ${e.toString()}');
    }
  }

  // INIT TRANSACTION
  Future<PaymentEntity> initializeTransaction({
    required double amount,
    required String email,
    required String dancerId,
    required String clientId,
  }) async {
    try {
      final response = await onlinePaymentInfo
          .post(endpoint: 'transaction/initialize', body: {
        'email': email,
        'amount': (amount * 100).toString(), // Paystack uses kobo
        'metadata': {
          'dancerId': dancerId,
          'clientId': clientId,
        }
      });

      debugPrint('Init payment response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] == null || data['data']['reference'] == null) {
          debugPrint('Invalid response from Paystack: ${data.toString()}');
          throw Exception('Invalid response from Paystack');
        }
        return PaymentEntity(
          reference: data['data']['reference'],
          amount: amount,
          email: email,
          dancerId: dancerId,
          clientId: clientId,
          authorizationUrl: data['data']['authorization_url'],
        );
      } else {
        throw Exception('Failed to initialize transaction');
      }
    } catch (e) {
      debugPrint(
        'Unexpected error with initializing transaction: ${e.toString()}',
      );
      return throw Exception(
        'Unexpected error with initializing transaction: ${e.toString()}',
      );
    }
  }

  // VERIFY TRANSACTION
  Future<PaymentEntity> verifyTransaction({required String reference}) async {
    try {
      final res = await onlinePaymentInfo.get(
          endpoint: 'transaction/verify/$reference');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return PaymentEntity(
          reference: reference,
          amount: data['data']['amount'] / 100,
          email: data['data']['customer']['email'],
          dancerId: data['data']['metadata']['dancerId'],
          clientId: data['data']['metadata']['clientId'],
          status: data['data']['status'],
          createdAt: DateTime.parse(data['data']['createdAt']),
        );
      } else {
        throw Exception('Failed to verify transaction');
      }
    } catch (e) {
      debugPrint(
        'Unexpected error while verifying transaction: ${e.toString()}',
      );

      return throw Exception(
        'Unexpected error while verifying transaction: ${e.toString()}',
      );
    }
  }

  // GET CLIENT TRANSACTIONS
  Future<List<PaymentEntity>> getClientTransactions({
    required String clientId,
  }) async {
    try {
      final res = await onlinePaymentInfo.get(
        endpoint: '/transaction',
        queryParams: {
          'metadata.clientId': clientId,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List<dynamic> transactions = data['data'];

        return transactions.map((transaction) {
          return PaymentEntity(
            reference: transaction['reference'],
            amount: transaction['amount'] / 100, // convert from kobo
            email: transaction['customer']['email'],
            dancerId: transaction['metadata']['dancerId'],
            clientId: transaction['metadata']['clientId'],
            status: transaction['status'],
            createdAt: DateTime.parse(transaction['created_at']),
          );
        }).toList();
      } else {
        throw Exception(
            'Failed to fetch transactions. Status code: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint(
        'Unexpected error while getting client transactions: ${e.toString()}',
      );

      return throw Exception(
        'Unexpected error while getting client transactions: ${e.toString()}',
      );
    }
  }
}
