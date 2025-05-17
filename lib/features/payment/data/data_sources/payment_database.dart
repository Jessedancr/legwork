import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:legwork/features/payment/domain/entities/payment_entity.dart';

class PaymentDatabase {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> saveTransaction({required PaymentEntity payment}) async {
    try {
      await db.collection('transactions').doc(payment.reference).set({
        'reference': payment.reference,
        'amount': payment.amount,
        'email': payment.email,
        'dancerId': payment.dancerId,
        'clientId': payment.clientId,
        'status': payment.status,
        'createdAt': payment.createdAt ?? FieldValue.serverTimestamp(),
        'verifiedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save transaction: ${e.toString()}');
    }
  }

  Stream<List<PaymentEntity>> getClientTransactions(String clientId) {
    return db
        .collection('transactions')
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return PaymentEntity(
                reference: data['reference'],
                amount: data['amount'],
                email: data['email'],
                dancerId: data['dancerId'],
                clientId: data['clientId'],
                status: data['status'],
                createdAt: data['createdAt']?.toDate(),
              );
            }).toList());
  }
}
