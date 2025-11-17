import 'package:flutter/material.dart';

class PaymentNotifScreen extends StatefulWidget {
  const PaymentNotifScreen({super.key});

  @override
  State<PaymentNotifScreen> createState() => _PaymentNotifScreenState();
}

class _PaymentNotifScreenState extends State<PaymentNotifScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.teal,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
