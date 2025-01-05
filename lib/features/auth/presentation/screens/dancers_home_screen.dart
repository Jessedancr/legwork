import 'package:flutter/material.dart';

class DancersHomeScreen extends StatefulWidget {
  const DancersHomeScreen({super.key});

  @override
  State<DancersHomeScreen> createState() => _DancersHomeScreenState();
}

class _DancersHomeScreenState extends State<DancersHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'DANCERS HOME SCREEN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
