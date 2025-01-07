import 'package:flutter/material.dart';

class DancersHomeScreen extends StatefulWidget {
  final String uid;
  const DancersHomeScreen({
    super.key,
    required this.uid,
  });

  @override
  State<DancersHomeScreen> createState() => _DancersHomeScreenState();
}

class _DancersHomeScreenState extends State<DancersHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text(
              'DANCERS HOME SCREEN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.uid),
          ],
        ),
      ),
    );
  }
}
