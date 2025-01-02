import 'package:flutter/material.dart';

class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({super.key});

  @override
  State<ClientSignUpScreen> createState() => _ClientSignUpScreenState();
}

class _ClientSignUpScreenState extends State<ClientSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('CLIENT SIGN UP SCREEN'),
      ),
    );
  }
}
