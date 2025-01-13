import 'package:flutter/material.dart';

class ClientProfileCompletionFlow extends StatefulWidget {
  final String email;
  const ClientProfileCompletionFlow({
    super.key,
    required this.email,
  });

  @override
  State<ClientProfileCompletionFlow> createState() =>
      _ClientProfileCompletionFlowState();
}

class _ClientProfileCompletionFlowState
    extends State<ClientProfileCompletionFlow> {
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
