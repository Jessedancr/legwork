import 'package:flutter/material.dart';

class ClientsHomeScreen extends StatefulWidget {
  final String email;
  const ClientsHomeScreen({
    super.key,
    required this.email,
  });

  @override
  State<ClientsHomeScreen> createState() => _ClientsHomeScreenState();
}

class _ClientsHomeScreenState extends State<ClientsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text(
              'CLIENTS HOME SCREEN',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.email),
          ],
        ),
      ),
    );
  }
}
