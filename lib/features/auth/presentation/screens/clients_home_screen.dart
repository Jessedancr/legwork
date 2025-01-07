import 'package:flutter/material.dart';

class ClientsHomeScreen extends StatefulWidget {
  const ClientsHomeScreen({super.key});

  @override
  State<ClientsHomeScreen> createState() => _ClientsHomeScreenState();
}

class _ClientsHomeScreenState extends State<ClientsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'CLIENTS HOME SCREEN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
