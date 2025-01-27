import 'package:flutter/material.dart';

class ClientMessagesScreen extends StatefulWidget {
  const ClientMessagesScreen({super.key});

  @override
  State<ClientMessagesScreen> createState() => _ClientMessagesScreenState();
}

class _ClientMessagesScreenState extends State<ClientMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('CLIENT MESSAGES SCREEN'),
    );
  }
}
